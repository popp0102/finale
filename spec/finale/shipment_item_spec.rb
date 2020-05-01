require 'spec_helper'

RSpec.describe Finale::ShipmentItem do
  describe '#format_for_post' do
    subject { shipment_item.format_for_post('account') }

    let(:shipment_item) { Finale::ShipmentItem.new(product_id: product_id, facility_id: facility_id, quantity: quantity, lot_id: lot_id) }
    let(:product_id) { 'product_1' }
    let(:facility_id) { 'facility_1' }
    let(:quantity) { 1 }
    let(:lot_id) { 'L_F0AAAAA-U0' }

    let(:expected) {
      {
        productUrl: 'account/api/product/product_1',
        facilityUrl: 'account/api/facility/facility_1',
        quantity: 1,
        lotId: 'L_F0AAAAA-U0'
      }
    }

    it { is_expected.to eql(expected) }

    context 'lot_id without the prefix' do
      let(:lot_id) { 'F0AAAAA-U0' }

      it { is_expected.to eql(expected) }
    end

    context 'lot_id without the prefix' do
      let(:lot_id) { nil }
      let(:expected) {
        {
          productUrl: 'account/api/product/product_1',
          facilityUrl: 'account/api/facility/facility_1',
          quantity: 1
        }
      }

      it { is_expected.to eql(expected) }
    end
  end
end
