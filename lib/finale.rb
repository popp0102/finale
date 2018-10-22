require "rest-client"
require "json"

require "finale/version"
require "finale/errors"
require "finale/order"
require "finale/shipment"

module Finale
  class Client
    MAX_REQUESTS = 100 # Finale API Usage: 'https://support.finaleinventory.com/hc/en-us/articles/115007830648-Getting-Started'
    BASE_URL     = 'https://app.finaleinventory.com'

    def initialize(company)
      @cookies       = nil
      @request_count = 0
      @company       = company
      @login_url     = construct_url(:auth)
      @order_url     = construct_url(:order)
      @shipment_url  = construct_url(:shipment)
    end

    def login(username: nil, password: nil)
      payload = {
        username: username || ENV['FINALE_USERNAME'],
        password: password || ENV['FINALE_PASSWORD']
      }

      request(verb: :LOGIN, payload: payload)
    end

    def get_order_ids
      body      = request(verb: :GET, url: @order_url)
      order_ids = body[:orderId]
      order_ids.map(&:to_i).sort.uniq
    end

    def get_order(id)
      response = request(verb: :GET, url: "#{@order_url}/#{id}")
      Order.new(response)
    end

    def get_shipments(order)
      order.shipment_urls.map do |suffix_url|
        url      = "#{BASE_URL}#{suffix_url}"
        response = request(verb: :GET, url: url)
        Shipment.new(response)
      end
    end

    private

    def construct_url(resource)
      "#{BASE_URL}/#{@company}/api/#{resource}"
    end

    def request(verb: nil, url: nil, payload: nil)
      raise MaxRequests.new(MAX_REQUESTS) if @request_count >= MAX_REQUESTS
      raise NotLoggedIn.new(verb: verb, url: url) unless verb == :LOGIN || !@cookies.nil?

      case verb
      when :LOGIN
        response = RestClient.post(@login_url, payload)
        @cookies = response.cookies
      when :GET
        response = RestClient.get(url, cookies: @cookies)
      when :POST
        response = RestClient.post(url, cookies: @cookies)
      end

      @request_count += 1
      body = JSON.parse(response.body, symbolize_names: true)
      body
    end
  end
end

