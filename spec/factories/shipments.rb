FactoryBot.define do
  factory :finale_shipment, class: Finale::Shipment do
    transient do
      options { {} }
    end

    shipment_response { build(:finale_shipment_response, **options) }

    initialize_with do
      new(shipment_response)
    end
  end
end
