require 'spec_helper'
require 'pry'

RSpec.describe Finale::Client do
  let(:client)        { Finale::Client.new(account: 'some_account', throttle_mode: throttle_mode) }
  let(:throttle_mode) { false }

  describe '#login' do
    subject { client.login(username: username, password: password) }

    let(:username) { 'some_username' }
    let(:password) { 'some_password' }

    it { expect{subject}.to_not raise_error }

    it 'should set cookies' do
      subject
      expect(client.instance_variable_get(:@cookies)).to_not be_nil
    end

    context 'fall back to environment variables' do
      let(:username) { nil }
      let(:password) { nil }

      it { expect{subject}.to_not raise_error }

      it 'should set cookies' do
        subject
        expect(client.instance_variable_get(:@cookies)).to_not be_nil
      end
    end
  end

  describe '#request' do
    subject { client.send(:request, verb: verb, url: 'some_url', payload: {}) }

    context 'not logged in yet' do
      let(:verb) { :GET }
      it { expect{subject}.to raise_error(Finale::NotLoggedIn) }
    end

    context 'max requests made' do
      let(:verb) { :LOGIN }
      before(:each) do
        client.instance_variable_set(:@request_count, Finale::Client::REQUEST_LIMIT)
      end

      it 'should call handle_throttle' do
        expect(client).to receive(:handle_throttling)
        subject
      end
    end
  end

  context '#handle_throttling' do
    subject { client.send(:handle_throttling) }

    context 'Throttle Mode On' do
      let(:throttle_mode) { true }

      before(:each) do
        allow_any_instance_of(Kernel).to receive(:sleep)
        client.instance_variable_set(:@request_count, Finale::Client::REQUEST_LIMIT)
      end

      it { expect{subject}.to_not raise_error }

      it 'should sleep' do
        expect_any_instance_of(Kernel).to receive(:sleep)
        subject
      end

      it 'should reset request_count' do
        subject
        request_count = client.instance_variable_get(:@request_count)
        expect(request_count).to eq(0)
      end
    end

    context 'Throttle Mode Off' do
      let(:throttle_mode) { false }

      it 'should reset request_count' do
        expect{subject}.to raise_error(Finale::MaxRequests)
        request_count = client.instance_variable_get(:@request_count)
        expect(request_count).to eq(0)
      end
    end
  end

  describe 'resource methods' do
    before(:each) do
      client.login
    end

    describe '#get_order' do
      subject { client.get_order(order_id) }

      before(:each) do
        stub_request(:get, /.*\/order\/#{order_id}/).to_return(status: 200, body: order_response.to_json)
      end

      let(:order_id) { "12345" }
      let(:order_response) { build(:finale_order_response, id: order_id) }

      it { expect{subject}.to_not raise_error }
      it { is_expected.to be_a(Finale::Order) }
    end

    describe '#get_orders' do
      subject { client.get_orders(filter_params) }

      before(:each) do
        stub_request(:get, /.*\/order/).to_return(status: 200, body: order_collection.to_json)
      end

      let(:order_collection) { build(:finale_order_collection) }
      let(:filter_params) { {} }

      it { expect{subject}.to_not raise_error }
      it { is_expected.to all(be_a(Finale::Order)) }

      context 'with lastUpdatedDate filter' do
        let(:filter_params) { {last_updated_date: [1.days.ago, Time.now]} }
        it { expect{subject}.to_not raise_error }
      end

      context 'with orderTypeId filter' do
        let(:filter_params) { {order_type_id: 'SALES_ORDER'} }
        it { expect{subject}.to_not raise_error }
      end
    end

    describe '#get_shipment' do
      subject { client.get_shipment(shipment_id) }

      before(:each) do
        stub_request(:get, /.*\/shipment\/#{shipment_id}/).to_return(status: 200, body: shipment_response.to_json)
      end

      let(:shipment_id) { "12345" }
      let(:shipment_response) { build(:finale_shipment_response, id: shipment_id) }

      it { expect{subject}.to_not raise_error }
      it { is_expected.to be_a(Finale::Shipment) } end


    describe '#get_shipments' do
      subject { client.get_shipments(filter_params) }

      before(:each) do
        stub_request(:get, /.*\/shipment/).to_return(status: 200, body: shipment_collection.to_json)
      end

      let(:shipment_collection) { build(:finale_shipment_collection) }
      let(:filter_params) { {} }

      it { expect{subject}.to_not raise_error }
      it { is_expected.to all(be_a(Finale::Shipment)) }

      context 'with lastUpdatedDate filter' do
        let(:filter_params) { {last_updated_date: [1.days.ago, Time.now]} }
        it { expect{subject}.to_not raise_error }
      end

      context 'with shipmentTypeId filter' do
        let(:filter_params) { {shipment_type_id: 'SALES_SHIPMENT'} }
        it { expect{subject}.to_not raise_error }
      end
    end

    describe '#get_shipments_from_order' do
      subject { client.get_shipments_from_order(order) }

      before(:each) do
        stub_request(:get, /.*#{suffix_1}/).to_return(status: 200, body: shipment_response_1.to_json)
        stub_request(:get, /.*#{suffix_2}/).to_return(status: 200, body: shipment_response_2.to_json)
      end

      let(:suffix_1) { order.shipmentUrlList[0] }
      let(:suffix_2) { order.shipmentUrlList[1] }

      let(:shipment_id_1) { '11111' }
      let(:shipment_id_2) { '11112' }

      let(:shipment_response_1) { build(:finale_shipment_response, id: shipment_id_1) }
      let(:shipment_response_2) { build(:finale_shipment_response, id: shipment_id_2) }

      let(:order) { build(:finale_order, shipment_id1: shipment_id_1, shipment_id2: shipment_id_2) }

      it { expect{subject}.to_not raise_error }
      it { is_expected.to be_a(Array) }
      it { is_expected.to all(be_a(Finale::Shipment)) }
    end

    describe '#get_order_from_shipment' do
      subject { client.get_order_from_shipment(shipment) }

      before(:each) do
        stub_request(:get, /.*\/order/).to_return(status: 200, body: order.to_json)
      end

      let(:order) { build(:finale_order) }
      let(:shipment) { build(:finale_shipment, order_id: order.orderId) }

      it { expect{subject}.to_not raise_error }
      it { is_expected.to be_a(Finale::Order) }
    end

    describe '#get_facilities' do
      subject { client.get_facilities }

      before(:each) do
        stub_request(:get, /.*\/facility/).to_return(status: 200, body: facility_collection.to_json)
      end

      let(:facility_collection) { build(:finale_facility_collection) }

      it { expect{subject}.to_not raise_error }
      it { is_expected.to all(be_a(Finale::Facility)) }
    end

    describe '#create_shipment_for_order' do
      subject { client.create_shipment_for_order(order_id, items) }

      before(:each) do
        stub_request(:post, /.*\/shipment/).to_return(status: 200, body: response.to_json)
      end

      let(:order_id) { 'some_id' }
      let(:item1) { build(:finale_shipment_item, product_id: 'product_1', facility_id: 'facility_1', quantity: 1, lot_id: 'L_F0AAAAA-U0') }
      let(:item2) { build(:finale_shipment_item, product_id: 'product_2', facility_id: 'facility_1', quantity: 1, lot_id: 'F0BBBBB-U0') }
      let(:item3) { build(:finale_shipment_item, product_id: 'product_3', facility_id: 'facility_3', quantity: 3, lot_id: nil) }
      let(:items) { [item1, item2, item3] }

      let(:response) { build(:finale_shipment_response) }

      it { expect{subject}.to_not raise_error }
      it { is_expected.to be_a(Finale::Shipment) }
    end

    describe '#pack_shipment' do
      subject { client.pack_shipment(shipment) }

      before(:each) do
        stub_request(:post, /.*\/shipment\/.*\/pack/).to_return(status: 200, body: shipment.to_json)
      end

      let(:shipment) { build(:finale_shipment) }

      it { expect{subject}.to_not raise_error }
      it { is_expected.to be_a(Finale::Shipment) }
    end

  end
end
