FactoryBot.define do
  factory :order_response, class: Hash do
    id { "10012" }
    shipment_id1 { '10022' }
    shipment_id2 { '10023' }

    initialize_with do
      {
        orderId: id,
        orderUrl: "/demo/api/order/#{id}",
        orderTypeId: "SALES_ORDER",
        orderHistoryListUrl: "/demo/api/order/#{id}/history/",
        saleSourceId: 'some_source_id',
        actionUrlLock: "/demo/api/order/#{id}/lock",
        actionUrlComplete: "/demo/api/order/#{id}/complete",
        actionUrlCancel: "/demo/api/order/#{id}/cancel",
        reserveAllUrl: "/demo/api/order/#{id}/reserveall",
        statusId: "ORDER_CREATED",
        originFacilityUrl: "/demo/api/facility/10000",
        orderItemList:  [
          {
            orderItemUrl: "/demo/api/order/#{id}/orderItem/00000001",
            reserveUrl: "/demo/api/order/#{id}/orderItem/00000001/reserve",
            productId: "BP2905",
            productUrl: "/demo/api/product/BP2905",
            unitListPrice: 16.56,
            unitPrice: 16.56,
            quantity: 4
          },
          {
            orderItemUrl: "/demo/api/order/#{id}/orderItem/00000002",
            reserveUrl: "/demo/api/order/#{id}/orderItem/00000002/reserve",
            productId: "PH-1361",
            productUrl: "/demo/api/product/PH-1361",
            unitListPrice: 466.52,
            unitPrice: 466.52,
            normalizedPackingString: "36 cs 36/1",
            quantity: 12
          }
        ],
        orderAdjustmentList: [],
        orderRoleList: [],
        shipmentUrlList: ["/demo/api/shipment/#{shipment_id1}","/demo/api/shipment/#{shipment_id2}"]
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
