FactoryBot.define do
  factory :order_response, class: Hash do
    id { '100001' }
    shipment_id1 { '10208' }
    shipment_id2 { '10209' }

    initialize_with do
      {
        orderId: id,
        shipmentUrlList: ["/account/api/shipment/#{shipment_id1}", "/account/api/shipment/#{shipment_id2}"],
        saleSourceId: 'Prospect'
      }
    end
  end

  factory :order_ids_response, class: Hash do
    order_id1 { '100001' }
    order_id2 { '100002' }
    order_id3 { '100003' }
    order_id4 { '100004' }

    initialize_with do
      {
        orderId: [order_id1, order_id2, order_id3, order_id4],
        # A lot of other fields we are ignoring right now
      }
    end
  end
end

