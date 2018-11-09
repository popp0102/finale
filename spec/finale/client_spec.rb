require 'spec_helper'
require 'pry'

RSpec.describe Finale::Client do
  let(:client)         { Finale::Client.new(account: 'some_account', throttle_mode: throttle_mode) }
  let(:throttle_mode)  { false }
  let(:base_url)       { Finale::Client::BASE_URL }
  let(:order_url)      { client.instance_variable_get(:@order_url) }
  let(:shipment_url)   { client.instance_variable_get(:@shipment_url) }
  let(:login_url)      { client.instance_variable_get(:@login_url) }

  before(:each) do
    login_headers  = {'Set-Cookie' => 'JSESSIONID=some_session_id' }
    login_response = build(:login_response)

    stub_request(:post, login_url).to_return(status: 200, body: login_response.to_json, headers: login_headers)
  end

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

    context 'Throttle Mode On' do
      let(:throttle_mode) { false }

      it { expect{subject}.to raise_error(Finale::MaxRequests) }
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
        stub_request(:get, /#{order_url}\/#{order_id}/).to_return(status: 200, body: order_response.to_json)
      end

      let(:order_id) { "12345" }
      let(:order_response) { build(:order_response, id: order_id) }

      it { expect{subject}.to_not raise_error }
      it { is_expected.to be_a(Finale::Order) }
    end

    describe '#get_orders' do
      subject { client.get_orders(filter_params) }

      before(:each) do
        stub_request(:get, /#{order_url}/).to_return(status: 200, body: order_collection.to_json)
      end

      let(:order_collection) { build(:order_collection) }
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
        stub_request(:get, /#{shipment_url}\/#{shipment_id}/).to_return(status: 200, body: shipment_response.to_json)
      end

      let(:shipment_id) { "12345" }
      let(:shipment_response) { build(:shipment_response, id: shipment_id) }

      it { expect{subject}.to_not raise_error }
      it { is_expected.to be_a(Finale::Shipment) } end


    describe '#get_shipments' do
      subject { client.get_shipments(filter_params) }

      before(:each) do
        stub_request(:get, /#{shipment_url}/).to_return(status: 200, body: shipment_collection.to_json)
      end

      let(:shipment_collection) { build(:shipment_collection) }
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
        stub_request(:get, "#{base_url}#{suffix_1}").to_return(status: 200, body: shipment_response_1.to_json)
        stub_request(:get, "#{base_url}#{suffix_2}").to_return(status: 200, body: shipment_response_2.to_json)
      end

      let(:suffix_1) { order.shipmentUrlList[0] }
      let(:suffix_2) { order.shipmentUrlList[1] }

      let(:shipment_id_1) { '11111' }
      let(:shipment_id_2) { '11112' }

      let(:shipment_response_1) { build(:shipment_response, id: shipment_id_1) }
      let(:shipment_response_2) { build(:shipment_response, id: shipment_id_2) }

      let(:order) { build(:order, shipment_id1: shipment_id_1, shipment_id2: shipment_id_2) }

      it { expect{subject}.to_not raise_error }
      it { is_expected.to be_a(Array) }
      it { is_expected.to all(be_a(Finale::Shipment)) }
    end

    describe '#get_order_from_shipment' do
      subject { client.get_order_from_shipment(shipment) }

      before(:each) do
        stub_request(:get, /#{order_url}/).to_return(status: 200, body: order.to_json)
      end

      let(:order) { build(:order) }
      let(:shipment) { build(:shipment, order_id: order.orderId) }

      it { expect{subject}.to_not raise_error }
      it { is_expected.to be_a(Finale::Order) }
    end
  end
end

