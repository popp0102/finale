FactoryBot.define do
  factory :finale_order, class: Finale::Order do
    transient { shipment_id1 { '10001' } }
    transient { shipment_id2 { '10002' } }
    order_response { build(:finale_order_response, shipment_id1: shipment_id1, shipment_id2: shipment_id2) }

    initialize_with do
     new(order_response)
    end
  end
end

