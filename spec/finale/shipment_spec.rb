require 'spec_helper'

RSpec.describe Finale::Shipment do
  describe '#initialize from shipment_response' do
    subject { Finale::Shipment.new(shipment_response) }

    let(:shipment_response) { build(:finale_shipment_response) }

    it { expect{subject}.to_not raise_error }
  end

  describe 'using the factory' do
    subject { build(:finale_shipment) }

    it { expect{subject}.to_not raise_error }
    it { is_expected.to be_a(Finale::Shipment) }

    describe '#lot_ids' do
      subject { shipment.lot_ids }

      let(:lot_id1) { 'some_lot_id_1' }
      let(:lot_id2) { 'some_lot_id_2' }
      let(:shipment) { build(:finale_shipment, options: { lot_id1: lot_id1, lot_id2: lot_id2 }) }

      it { expect{subject}.to_not raise_error }
      it { expect(subject).to include(lot_id1, lot_id2) }

      context 'empty lot id compacts' do
        let(:lot_id2) { nil }

        it { expect{subject}.to_not raise_error }
        it { expect(subject).to eq([lot_id1]) }
      end

      context 'empty shipment item list' do
        let(:shipment) { build(:finale_shipment, options: { shipment_item_list: nil}) }

        it { expect{subject}.to_not raise_error }
        it { expect(subject).to eq([]) }
      end
    end

    describe '#order_id' do
      subject { shipment.order_id }

      let(:order_id) { 'some_order_id' }
      let(:shipment) { build(:finale_shipment, options: { order_id: order_id }) }

      it { expect{subject}.to_not raise_error }
      it { expect(subject).to eq(order_id) }
    end
  end
end
