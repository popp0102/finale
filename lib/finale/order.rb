module Finale
  class Order
    attr_reader :id, :shipment_urls, :source

    def initialize(order_response)
      @id            = order_response[:orderId]&.to_i
      @shipment_urls = order_response[:shipmentUrlList]
      @source        = order_response[:saleSourceId]
    end
  end
end

