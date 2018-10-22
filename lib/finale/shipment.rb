module Finale
  class Shipment
    attr_reader :id, :item_list

    def initialize(shipment_response)
      @id        = shipment_response[:shipmentId]&.to_i
      @item_list = shipment_response[:shipmentItemList]
    end
  end
end

