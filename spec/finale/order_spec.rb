require 'spec_helper'

RSpec.describe Finale::Order do
  let(:order_response) { build(:finale_order_response) }

  describe '#initialize' do
    subject { Finale::Order.new(order_response) }

    it { expect{subject}.to_not raise_error }

    it 'should have an id' do
      expect(subject.id).to be_an(Integer)
    end

    it 'should have a source' do
      expect(subject.source).to be_a(String)
    end

    it 'should have shipment_urls' do
      expect(subject.shipment_urls).to be_an(Array)
    end

  end
end

