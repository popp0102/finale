require 'spec_helper'

RSpec.describe Finale::Shipment do
  let(:shipment_response) { build(:shipment_response) }

  describe '#initialize' do
    subject { Finale::Shipment.new(shipment_response) }

    it { expect{subject}.to_not raise_error }
  end
end

