FactoryBot.define do
  factory :shipment, class: Finale::Shipment do
    shipment_response { build(:shipment_response, order_id: order_id) }

    transient do
      order_id { '11111' }
    end

    initialize_with do
     new(shipment_response)
    end
  end
end

