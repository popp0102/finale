FactoryBot.define do
  factory :shipment, class: Finale::Shipment do
    shipment_response { build(:shipment_response) }

    initialize_with do
     new(shipment_response)
    end
  end
end

