require 'spec_helper'

RSpec.describe Finale::Order do
  describe '#initialize from an order_response' do
    subject { Finale::Order.new(order_response) }

    let(:order_response) { build(:finale_order_response) }

    it { expect{subject}.to_not raise_error }
    it { expect(subject.orderId).to be_a(String) }
    it { expect(subject.saleSourceId).to be_a(String) }
    it { expect(subject.shipmentUrlList).to be_an(Array) }
  end

  describe 'using the factory' do
    subject { build(:finale_order) }

    it { is_expected.to be_a(Finale::Order) }

    context 'specifying values' do
      subject { build(:finale_order, options: { saleSourceId: 'My Store' }) }

      it { expect(subject.saleSourceId).to eql('My Store') }
      it { is_expected.to be_a(Finale::Order) }
    end
  end
end
