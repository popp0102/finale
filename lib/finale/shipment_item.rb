module Finale
  class ShipmentItem
    def initialize(product_id: , facility_id: , quantity: , lot_id: nil)
      @product_id = product_id
      @facility_id = facility_id
      @quantity = quantity
      @lot_id = lot_id
    end

    def format_for_post(account)
      {
        productUrl: account + "/api/product/#{@product_id}",
        facilityUrl: account + "/api/facility/#{@facility_id}",
        quantity: @quantity,
        lotId: @lot_id&.rjust(12, 'L_') # L_F0137A3-U0
      }.compact
    end
  end
end
