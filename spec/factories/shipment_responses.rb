FactoryBot.define do
  factory :shipment_response, class: Hash do
    id { '10208' }

    initialize_with do
      {
        shipmentId: id,
        shipmentItemList: [
          {lotId: 'L_F005FFF-U0', facilityUrl: '/account/api/facility/10008', productId: 'NOTG-3S1BW',   productUrl: '/account/api/product/NOTG-3S1BW',   quantity: 0},
          {lotId: 'L_F005A58-J0', facilityUrl: '/account/api/facility/10018', productId: 'NOTG-3S1BW-J', productUrl: '/account/api/product/NOTG-3S1BW-J', quantity: 1}
        ],
        statusId: 'SHIPMENT_CANCELLED'
      # A lot of other fields we are ignoring right now
      }
    end
  end
end

