FactoryBot.define do
  factory :finale_shipment, class: Finale::Shipment do
    shipment_response { build(:finale_shipment_response) }

    initialize_with do
     new(shipment_response)
    end
  end
end

