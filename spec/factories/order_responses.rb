FactoryBot.define do
  factory :order_response, class: Hash do
    id           { '10012' }
    shipment_id1 { '10022' }
    shipment_id2 { '10023' }

    initialize_with do
      {
        orderId: id,
        orderUrl: "/demo/api/order/#{id}",
        orderTypeId: 'SALES_ORDER',
        orderHistoryListUrl: "/demo/api/order/#{id}/history/",
        saleSourceId: 'some_source_id',
        actionUrlLock: "/demo/api/order/#{id}/lock",
        actionUrlComplete: "/demo/api/order/#{id}/complete",
        actionUrlCancel: "/demo/api/order/#{id}/cancel",
        reserveAllUrl: "/demo/api/order/#{id}/reserveall",
        statusId: 'ORDER_CREATED',
        originFacilityUrl: '/demo/api/facility/10000',
        orderItemList:  [
          {
            orderItemUrl: "/demo/api/order/#{id}/orderItem/00000001",
            reserveUrl: "/demo/api/order/#{id}/orderItem/00000001/reserve",
            productId: 'BP2905',
            productUrl: '/demo/api/product/BP2905',
            unitListPrice: 16.56,
            unitPrice: 16.56,
            quantity: 4
          },
          {
            orderItemUrl: "/demo/api/order/#{id}/orderItem/00000002",
            reserveUrl: "/demo/api/order/#{id}/orderItem/00000002/reserve",
            productId: 'PH-1361',
            productUrl: '/demo/api/product/PH-1361',
            unitListPrice: 466.52,
            unitPrice: 466.52,
            normalizedPackingString: '36 cs 36/1',
            quantity: 12
          }
        ],
        orderAdjustmentList: [],
        orderRoleList: [],
        shipmentUrlList: ["/demo/api/shipment/#{shipment_id1}","/demo/api/shipment/#{shipment_id2}"]
      }
    end
  end

  factory :order_collection, class: Hash do
    account   { 'some_account' }
    order_id1 { '10012' }
    order_id2 { '10013' }

    initialize_with do
      {
        orderId: [order_id1, order_id2],
        orderUrl: [ "/#{account}/api/order/#{order_id1}", "/#{account}/api/order/#{order_id2}"],
        orderTypeId: ['SALES_ORDER', 'SALES_ORDER'],
        statusId: ['ORDER_CANCELLED', 'ORDER_COMPLETED'],
        originFacilityUrl: ["/#{account}/api/facility/200", "/#{account}/api/facility/200"],
        orderItemList: [
          [{
            orderItemUrl: "/demo/api/order/#{order_id1}/orderItem/00000001",
            reserveUrl: "/demo/api/order/#{order_id1}/orderItem/00000001/reserve",
            productId: 'BP2905',
            productUrl: '/demo/api/product/BP2905',
            unitListPrice: 16.56,
            unitPrice: 16.56,
            quantity: 4
          }],
          [{
            orderItemUrl: "/demo/api/order/#{order_id2}/orderItem/00000002",
            reserveUrl: "/demo/api/order/#{order_id2}/orderItem/00000002/reserve",
            productId: 'PH-1361',
            productUrl: '/demo/api/product/PH-1361',
            unitListPrice: 466.52,
            unitPrice: 466.52,
            normalizedPackingString: '36 cs 36/1',
            quantity: 12
          }]
        ],
        orderAdjustmentList: [[], []],
        orderRoleList: [[], []],
        shipmentUrlList: [
          ['/demo/api/shipment/shipment_id1','/demo/api/shipment/shipment_id2'],
          ['/demo/api/shipment/shipment_id3','/demo/api/shipment/shipment_id4'],
        ],
        saleSourceId: ['SomeSource1', 'SomeSource2'],
        lastUpdatedDate: ['2018-07-19T14:51:20', '2018-07-20T14:51:20'],
        createdDate: ['2017-07-19T14:51:20', '2017-07-20T14:51:20'],
        orderItemListTotal: [0, 0],
        contentList: [[], []],
        userFieldDataList: [[], []],
        publicNotes: ['Some Note 1', 'Some Note 2'],
        referenceNumber: [nil, nil],
        settlementTermId: [nil, nil],
        fulfillmentId: ['UPS', 'Fedex',],
        requestedShippingServiceId: [nil, nil],
        orderDate: ['2018-07-23T14:12:56', '2018-07-23T14:12:56'],
        contactMechList: [nil, nil],
        privateNotes: [nil, nil],
        destinationFacilityUrl: [nil, nil],
        invoiceUrlList: [nil, nil]
      }
    end
  end
end

