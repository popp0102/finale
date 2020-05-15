FactoryBot.define do
  factory :finale_shipment_item, class: Finale::ShipmentItem do
    product_id  { 'some_product_id' }
    facility_id { 10001 }
    quantity    { 1 }
    lot_id      { 'L_F0BBBBB-U0' }

    initialize_with do
      new(product_id: product_id, facility_id: facility_id, quantity: quantity, lot_id: lot_id)
    end
  end
end
