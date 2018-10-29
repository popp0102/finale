FactoryBot.define do
  factory :shipment_response, class: Hash do
    id       { '11069' }
    account  { 'some_account' }
    order_id { '44444' }
    lot_id1  { 'L_F0BBBBB-U0' }
    lot_id2  { 'L_F00CCCC-U0' }

    initialize_with do
      {
        shipmentId: "#{id}",
        shipmentIdUser: "some_shipment_user_id-1",
        shipmentUrl: "/#{account}/api/shipment/#{id}",
        shipmentTypeId: "SALES_SHIPMENT",
        actionUrlCancel: "/#{account}/api/shipment/#{id}/cancel",
        actionUrlPack: "/#{account}/api/shipment/#{id}/pack",
        actionUrlUnpack: "/#{account}/api/shipment/#{id}/unpack",
        actionUrlShip: "/#{account}/api/shipment/#{id}/ship",
        actionUrlTransfer: "/#{account}/api/shipment/#{id}/transfer",
        primaryOrderUrl: "/#{account}/api/order/#{order_id}",
        statusId: "SHIPMENT_SHIPPED",
        packDate: "2016-09-26T18:00:00",
        shipDate: "2016-09-26T18:00:00",
        lastUpdatedDate: "2018-07-30T17:57:29",
        createdDate: "2018-07-30T17:56:59",
        facilityUrlPack: "/#{account}/api/facility/10022",
        userFieldDataList: [],
        shipmentItemList: [
          {
            lotId: lot_id1,
            facilityUrl: "/#{account}/api/facility/10022",
            productId: "some_product_id",
            productUrl: "/#{account}/api/product/some_product_id",
            quantity: 1
          },
          {
            lotId: lot_id2,
            facilityUrl: "/#{account}/api/facility/10022",
            productId: "some_product_id",
            productUrl: "/#{account}/api/product/some_product_id",
            quantity: 1
          }
        ],
        contentList: [],
        transferList: [],
        statusIdHistoryList: []
      }
    end
  end

  factory :shipment_collection, class: Hash do
    account      { 'some_account' }
    order_id     { '11111' }
    shipment_id1 { '22222' }
    shipment_id2 { '33333' }

    initialize_with do
      {
        shipmentId: [shipment_id1, shipment_id2],
        shipmentIdUser: ["some_shipment_user_id-1", "some_shipment_user_id-2"],
        shipmentUrl: ["/#{account}/api/shipment/#{shipment_id1}", "/#{account}/api/shipment/#{shipment_id2}"],
        shipmentTypeId: ["SALES_SHIPMENT", "SALES_SHIPMENT"],
        primaryOrderUrl: ["/#{account}/api/order/#{order_id}", "/#{account}/api/order/#{order_id}"],
        statusId: ["SHIPMENT_SHIPPED", "SHIPMENT_SHIPPED"],
        packDate: ["2016-09-26T18:00:00", "2016-09-26T18:00:00"],
        shipDate: ["2016-09-26T18:00:00", "2016-09-26T18:00:00"],
        userFieldDataList: [],
        shipmentItemList: [
          [{
            lotId: "L_F0BBBBB-U0",
            facilityUrl: "/#{account}/api/facility/10022",
            productId: "some_product_id",
            productUrl: "/#{account}/api/product/some_product_id",
            quantity: 1
          }],
          [{
            lotId: "L_F0CCCCC-U0",
            facilityUrl: "/#{account}/api/facility/10022",
            productId: "some_product_id",
            productUrl: "/#{account}/api/product/some_product_id",
            quantity: 1
          }]
        ],
        transferList: [[], []],
        statusIdHistoryList: [[], []],
        destinationFacilityUrl: [nil, nil],
        originFacilityUrl: ["/#{account}/api/facility/200", "/#{account}/api/facility/200"],
        receiveDate: ['2018-01-19T14:51:20', '2018-01-20T14:51:20'],
        facilityUrlPack: ["/#{account}/api/facility/10022", "/#{account}/api/facility/10022"],
        contentList: [[], []],
        createdDate: ['2017-07-19T14:51:20', '2017-07-20T14:51:20'],
        lastUpdatedDate: ['2018-07-19T14:51:20', '2018-07-20T14:51:20'],
        unpackDate: ['2018-07-19T14:51:20', '2018-07-20T14:51:20'],
        primaryReturnUrl: [nil, nil],
        receiveDateEstimated: [nil, nil],
        countPackages: [1, 1],
        trackingCode: ['some_tracking_code_1', 'some_tracking_code_2'],
        shipDateEstimated: ["2016-09-26T18:00:00", "2016-09-26T18:00:00"],
        externalUrl: [nil, nil],
      }
    end
  end
end

