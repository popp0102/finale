module Finale
  class Shipment < OpenStruct
    def lot_ids
      shipmentItemList.map { |item| item[:lotId] }.compact
    end
  end
end

