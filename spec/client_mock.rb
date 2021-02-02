module Finale
  class ClientMock < Client
    def initialize(account: nil, throttle_mode: false)
      @stubbed_responses = {}
      super
    end

    def login(username: nil, password: nil)
      @cookies = { 'JSESSIONID' => '123' }
    end

    def stub_responses(method_name, value)
      @stubbed_responses.merge!(method_name.to_sym => value)
    end

    def get_shipment(id)
      verify_login
      get_stubbed_response(:get_shipment) || FactoryBot.build(:finale_shipment, options: { id: id })
    end

    def get_order(id)
      verify_login
      get_stubbed_response(:get_order) || FactoryBot.build(:finale_order, options: { id: id })
    end

    def get_orders(filter: {}, order_type_id: nil, last_updated_date: nil)
      # Doesn't respect params
      verify_login
      get_stubbed_response(:get_orders) || [ FactoryBot.build(:finale_order), FactoryBot.build(:finale_order) ]
    end

    def get_shipments(filter: {}, shipment_type_id: nil, last_updated_date: nil)
      # Doesn't respect params
      verify_login
      get_stubbed_response(:get_shipments) || [ FactoryBot.build(:finale_shipment), FactoryBot.build(:finale_shipment) ]
    end

    def get_order_from_shipment(shipment)
      verify_login
      get_stubbed_response(:get_order_from_shipment) || FactoryBot.build(:finale_order, options: { id: shipment.order_id, shipment_id1: shipment.shipmentId })
    end

    def get_shipments_from_order(order)
      verify_login
      get_stubbed_response(:get_shipments_from_order) || [ FactoryBot.build(:finale_shipment, options: { order_id: order.orderId }) ]
    end

    def get_facilities
      verify_login
      get_stubbed_response(:get_facilities) || [ FactoryBot.build(:finale_facility), FactoryBot.build(:finale_facility) ]
    end

    def create_shipment_for_order(order_id, items)
      shipment_items = items.map { |item| item.format_for_post(@account) }
      verify_login
      get_stubbed_response(:create_shipment_for_order) || FactoryBot.build(:finale_shipment, options: { shipment_item_list: shipment_items })
    end

    def pack_shipment(shipment)
      verify_login
      shipment
    end

    private

    def verify_login
      raise NotLoggedIn.new(verb: '_', url: '_') unless @cookies&.dig('JSESSIONID').present?
    end

    def get_stubbed_response(method_name)
      @stubbed_responses[method_name]
    end

    def request(verb: nil, url: nil, payload: nil, filter: nil)
      puts "Warning: ClientMock missing method implementation. Blocking request to #{verb}: #{url}"
    end
  end
end
