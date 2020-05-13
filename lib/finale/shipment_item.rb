require_relative 'uri_helper'

module Finale
  class ShipmentItem
    include URIHelper

    def initialize(product_id: , facility_id: , quantity: , lot_id: nil)
      @product_id = product_id
      @facility_id = facility_id
      @quantity = quantity
      @lot_id = lot_id
    end

    def format_for_post(account)
      {
        productUrl: resource_path(:product, account: account, id: @product_id),
        facilityUrl: resource_path(:facility, account: account, id: @facility_id),
        quantity: @quantity,
        lotId: @lot_id&.rjust(12, 'L_') # L_F0137A3-U0
      }.compact
    end
  end
end
