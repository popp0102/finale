FactoryBot.define do
  factory :shipment_response, class: Hash do
    id { '11069' }

    initialize_with do
      {
        shipmentId: "#{id}",
        shipmentIdUser: "some_shipment_user_id-1",
        shipmentUrl: "/account/api/shipment/#{id}",
        shipmentTypeId: "SALES_SHIPMENT",
        actionUrlCancel: "/account/api/shipment/#{id}/cancel",
        actionUrlPack: "/account/api/shipment/#{id}/pack",
        actionUrlUnpack: "/account/api/shipment/#{id}/unpack",
        actionUrlShip: "/account/api/shipment/#{id}/ship",
        actionUrlTransfer: "/account/api/shipment/#{id}/transfer",
        primaryOrderUrl: "/account/api/order/some_shipment_user_id",
        statusId: "SHIPMENT_SHIPPED",
        packDate: "2016-09-26T18:00:00",
        shipDate: "2016-09-26T18:00:00",
        lastUpdatedDate: "2018-07-30T17:57:29",
        createdDate: "2018-07-30T17:56:59",
        facilityUrlPack: "/account/api/facility/10022",
        userFieldDataList: [],
        shipmentItemList: [
          {
            lotId: "L_F0BBBBB-U0",
            facilityUrl: "/account/api/facility/10022",
            productId: "some_product_id",
            productUrl: "/account/api/product/some_product_id",
            quantity: 1
          },
          {
            lotId: "L_F00CCCC-U0",
            facilityUrl: "/account/api/facility/10022",
            productId: "some_product_id",
            productUrl: "/account/api/product/some_product_id",
            quantity: 1
          }
        ],
        contentList: [],
        transferList: [],
        statusIdHistoryList: []
      }
    end
  end
end

