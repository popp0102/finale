require 'spec_helper'

RSpec.describe Finale::ClientMock do
  let(:client) { Finale::ClientMock.new(account: 'some_account') }

  describe '#login' do
    subject { client.login(username: 'username', password: 'password') }

    it { expect{subject}.to_not raise_error }
    it { subject; expect(client.instance_variable_get(:@cookies)).to eql({ 'JSESSIONID' => '123' }) }
  end

  describe 'raises error if client not logged in' do
    subject { client.get_order('any_id') }

    it { expect{subject}.to raise_error(Finale::NotLoggedIn) }
  end

  describe 'resource methods' do
    before(:each) do
      client.login
    end

    describe '#get_order' do
      subject { client.get_order('any_id') }

      it { expect{subject}.to_not raise_error }
      it { is_expected.to be_a(Finale::Order) }
      it { expect(subject.orderId).to eql('any_id') }

      context 'stubbed response' do
        before(:each) do
          client.stub_responses(:get_order, stubbed_response)
        end

        let(:stubbed_response) { build(:finale_order, options: { id: '123' }) }

        it { expect{subject}.to_not raise_error }
        it { is_expected.to eql(stubbed_response) }
      end
    end

    describe '#get_orders' do
      subject { client.get_orders() }

      it { expect{subject}.to_not raise_error }
      it { is_expected.to all(be_a(Finale::Order)) }

      context 'stubbed response' do
        before(:each) do
          client.stub_responses(:get_orders, stubbed_response)
        end

        let(:stubbed_response) { [build(:finale_order, options: { id: '123' })] }

        it { expect{subject}.to_not raise_error }
        it { is_expected.to eql(stubbed_response) }
      end
    end

    describe '#get_shipment' do
      subject { client.get_shipment('any_id') }

      it { expect{subject}.to_not raise_error }
      it { is_expected.to be_a(Finale::Shipment) }
      it { expect(subject.shipmentId).to eql('any_id') }

      context 'stubbed response' do
        before(:each) do
          client.stub_responses(:get_shipment, stubbed_response)
        end

        let(:stubbed_response) { build(:finale_shipment, options: { id: '123' }) }

        it { expect{subject}.to_not raise_error }
        it { is_expected.to eql(stubbed_response) }
      end
    end

    describe '#get_shipments' do
      subject { client.get_shipments() }

      it { expect{subject}.to_not raise_error }
      it { is_expected.to all(be_a(Finale::Shipment)) }

      context 'stubbed response' do
        before(:each) do
          client.stub_responses(:get_shipments, stubbed_response)
        end

        let(:stubbed_response) { [build(:finale_shipment, options: { id: '123' })] }

        it { expect{subject}.to_not raise_error }
        it { is_expected.to eql(stubbed_response) }
      end
    end

    describe '#get_shipments_from_order' do
      subject { client.get_shipments_from_order(order) }

      let(:order) { build(:finale_order) }

      it { expect{subject}.to_not raise_error }
      it { is_expected.to all(be_a(Finale::Shipment)) }
      it {
        shipments = subject
        order_urls = shipments.map(&:primaryOrderUrl)
        expect(order_urls).to all(match(/.*#{order.orderId}/))
      }

      context 'stubbed response' do
        before(:each) do
          client.stub_responses(:get_shipments_from_order, stubbed_response)
        end

        let(:stubbed_response) { [build(:finale_shipment, options: { id: '123' })] }

        it { expect{subject}.to_not raise_error }
        it { is_expected.to eql(stubbed_response) }
      end
    end

    describe '#get_order_from_shipment' do
      subject { client.get_order_from_shipment(shipment) }

      let(:shipment) { build(:finale_shipment) }

      it { expect{subject}.to_not raise_error }
      it { is_expected.to be_a(Finale::Order) }
      it { expect(subject.shipmentUrlList).to include(shipment.shipmentUrl) }

      context 'stubbed response' do
        before(:each) do
          client.stub_responses(:get_order_from_shipment, stubbed_response)
        end

        let(:stubbed_response) { [build(:finale_order, options: { id: '123' })] }

        it { expect{subject}.to_not raise_error }
        it { is_expected.to eql(stubbed_response) }
      end
    end

    describe '#get_facilities' do
      subject { client.get_facilities() }

      it { expect{subject}.to_not raise_error }
      it { is_expected.to all(be_a(Finale::Facility)) }

      context 'stubbed response' do
        before(:each) do
          client.stub_responses(:get_facilities, stubbed_response)
        end

        let(:stubbed_response) { [build(:finale_facility, options: { id: '123' })] }

        it { expect{subject}.to_not raise_error }
        it { is_expected.to eql(stubbed_response) }
      end
    end

    describe '#create_shipment_for_order' do
      subject { client.create_shipment_for_order(order_id, items) }

      let(:order_id) { 'some_id' }
      let(:item1) { build(:finale_shipment_item, product_id: 'product_1', facility_id: 'facility_1', quantity: 1, lot_id: 'L_F0AAAAA-U0') }
      let(:item2) { build(:finale_shipment_item, product_id: 'product_2', facility_id: 'facility_1', quantity: 1, lot_id: 'F0BBBBB-U0') }
      let(:item3) { build(:finale_shipment_item, product_id: 'product_3', facility_id: 'facility_3', quantity: 3, lot_id: nil) }
      let(:items) { [item1, item2, item3] }

      it { expect{subject}.to_not raise_error }
      it { is_expected.to be_a(Finale::Shipment) }
      it {
        shipment = subject
        lot_ids = shipment.shipmentItemList.map { |item| item[:lotId] }
        expect(lot_ids).to contain_exactly('L_F0AAAAA-U0', 'L_F0BBBBB-U0', nil)
      }

      context 'stubbed response' do
        before(:each) do
          client.stub_responses(:create_shipment_for_order, stubbed_response)
        end

        let(:stubbed_response) { [build(:finale_shipment, options: { id: '123' })] }

        it { expect{subject}.to_not raise_error }
        it { is_expected.to eql(stubbed_response) }
      end
    end

    describe '#pack_shipment' do
      subject { client.pack_shipment(shipment) }

      let(:shipment) { build(:finale_shipment) }

      it { expect{subject}.to_not raise_error }
      it { is_expected.to eql(shipment) }
    end
  end
end
