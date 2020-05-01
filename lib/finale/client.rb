require "rest-client"
require "json"
require "base64"
require "active_support/all"

require_relative"errors"
require_relative"facility"
require_relative"order"
require_relative"shipment"
require_relative"shipment_item"

module Finale
  class Client
    REQUEST_LIMIT = 100 # Finale API Usage: 'https://support.finaleinventory.com/hc/en-us/articles/115007830648-Getting-Started'
    BASE_URL      = 'https://app.finaleinventory.com'

    def initialize(account: nil, throttle_mode: false)
      @cookies       = nil
      @request_count = 0
      @throttle_mode = throttle_mode
      @account       = account
    end

    def login(username: nil, password: nil)
      payload = {
        username: username || ENV['FINALE_USERNAME'],
        password: password || ENV['FINALE_PASSWORD']
      }

      request(verb: :LOGIN, payload: payload)
    end

    def get_shipment(id)
      url = resource_url(:shipment) + '/' + id
      response = request(verb: :GET, url: url)
      Shipment.new(response)
    end

    def get_order(id)
      url = resource_url(:order) + '/' + id
      response = request(verb: :GET, url: url)
      Order.new(response)
    end

    def get_orders(filter: {}, order_type_id: nil, last_updated_date: nil)
      filter.merge!(lastUpdatedDate: last_updated_date) if last_updated_date.present?
      filter.merge!(orderTypeId: [order_type_id, order_type_id]) if order_type_id.present?

      url      = resource_url(:order)
      response = request(verb: :GET, url: url, filter: filter )
      rows     = column_major_to_row_major(response)

      rows.map { |r| Order.new(r) }
    end

    def get_shipments(filter: {}, shipment_type_id: nil, last_updated_date: nil)
      filter.merge!(lastUpdatedDate: last_updated_date) if last_updated_date.present?
      filter.merge!(shipmentTypeId: [shipment_type_id, shipment_type_id]) if shipment_type_id.present?

      url      = resource_url(:shipment)
      response = request(verb: :GET, url: url, filter: filter )
      rows     = column_major_to_row_major(response)

      rows.map { |r| Shipment.new(r) }
    end

    def get_order_from_shipment(shipment)
      get_order(shipment.order_id)
    end

    def get_shipments_from_order(order)
      (order.shipmentUrlList || []).map do |suffix_url|
        url      = BASE_URL + suffix_url
        response = request(verb: :GET, url: url)
        Shipment.new(response)
      end
    end

    def get_facilities
      url      = resource_url(:facility)
      response = request(verb: :GET, url: url)
      rows     = column_major_to_row_major(response)

      rows.map { |r| Facility.new(r) }
    end

    def create_shipment_for_order(order_id, items)
      order_url = @account + '/api/order/' + order_id
      shipment_items = items.map { |item| item.format_for_post(@account) }

      payload = {
        primaryOrderUrl: order_url,
        shipmentItemList: shipment_items,
        shipmentTypeId: 'SALES_SHIPMENT',
        shipmentUrl: nil
      }

      url      = resource_url(:shipment)
      response = request(verb: :POST, payload: payload, url: url)

      Shipment.new(response)
    end

    def pack_shipment(shipment)
      url = BASE_URL + shipment.actionUrlPack
      response = request(verb: :POST, url: url)

      Shipment.new(response)
    end

    private

    def column_major_to_row_major(column_major)
      row_major = []
      keys      = column_major.keys
      values    = column_major.values || [[]]
      num_cols  = values.count == 0 ? 0 : values.first.count
      num_cols.times do
        rowvals   = keys.map { |key| column_major[key].shift }
        row       = Hash[keys.zip(rowvals)]
        row_major << row
      end
      row_major
    end

    def resource_url(resource)
      "#{BASE_URL}/#{@account}/api/#{resource}"
    end

    def request(verb: nil, url: nil, payload: nil, filter: nil)
      handle_throttling if @request_count >= REQUEST_LIMIT
      raise NotLoggedIn.new(verb: verb, url: url) unless verb == :LOGIN || !@cookies.nil?

      case verb
      when :LOGIN
        url = resource_url(:auth)
        response = RestClient.post(url, payload)
        @cookies = response.cookies
      when :GET
        params = {}

        if filter.present?
          encoded_filter = Base64.encode64(filter.to_json)
          params.merge!(filter: encoded_filter)
        end

        response = RestClient.get(url, cookies: @cookies, params: params)
      when :POST
        payload ||= {}
        payload.merge!(sessionSecret: @cookies.dig('JSESSIONID'))
        response = RestClient.post(url, payload.to_json, cookies: @cookies)
      end

      @request_count += 1
      JSON.parse(response.body, symbolize_names: true)
    end

    def handle_throttling
      @request_count = 0

      if @throttle_mode
        sleep 60
      else
        raise MaxRequests.new(REQUEST_LIMIT)
      end
    end
  end
end

