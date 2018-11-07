module Finale
  class Shipment < OpenStruct
    def lot_ids
      (shipmentItemList || []).map { |item| item[:lotId] }.compact
    end

    def order_id
      self.primaryOrderUrl&.split('/')&.last
    end
  end
end

