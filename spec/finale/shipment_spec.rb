require 'spec_helper'

RSpec.describe Finale::Shipment do
  describe '#initialize' do
    subject { Finale::Shipment.new(shipment_response) }

    let(:shipment_response) { build(:shipment_response) }

    it { expect{subject}.to_not raise_error }
  end

  describe '#lot_ids' do
    subject { shipment.lot_ids }

    let(:lot_id1) { 'some_lot_id_1' }
    let(:lot_id2) { 'some_lot_id_2' }
    let(:shipment_response) { build(:shipment_response, lot_id1: lot_id1, lot_id2: lot_id2) }
    let(:shipment) { Finale::Shipment.new(shipment_response) }

    it { expect{subject}.to_not raise_error }
    it { expect(subject).to include(lot_id1, lot_id2) }

    context 'empty lot id compacts' do
      let(:lot_id2) { nil }

      it { expect{subject}.to_not raise_error }
      it { expect(subject).to eq([lot_id1]) }
    end
  end
end

