require 'spec_helper'

RSpec.describe Finale::URIHelper do
  let(:klass) { Finale::Client.new(account: 'some_account') }
  let(:base) { Finale::URIHelper.const_get(:BASE_URL) }

  describe '#url' do
    context 'for resource' do
      subject { klass.url(:shipments) }

      let(:expected) { "#{base}/some_account/api/shipments" }

      it { is_expected.to eq(expected) }

      context 'by id' do
        subject { klass.url(:shipments, id: 11) }

        let(:expected) { "#{base}/some_account/api/shipments/11" }

        it { is_expected.to eq(expected) }

        context 'with action' do
          subject { klass.url(:shipments, id: 11, action: :pack) }

          let(:expected) { "#{base}/some_account/api/shipments/11/pack" }

          it { is_expected.to eq(expected) }
        end
      end
    end

    context 'overriding url_base' do
      subject { klass.url(:shipments, url_base: 'http://other_domain') }

      let(:expected) { 'http://other_domain/some_account/api/shipments' }

      it { is_expected.to eq(expected) }
    end

    context 'overriding account' do
      subject { klass.url(:shipments, account: 'other_account') }

      let(:expected) { "#{base}/other_account/api/shipments" }

      it { is_expected.to eq(expected) }
    end
  end

  describe '#url_from_path' do
    subject { klass.url_from_path('a/resource/path') }

    let(:expected) { "#{base}/a/resource/path" }

    it { is_expected.to eq(expected) }

    context 'overriding url_base' do
      subject { klass.url_from_path('a/resource/path', url_base: 'http://other_domain') }

      let(:expected) { 'http://other_domain/a/resource/path' }

      it { is_expected.to eq(expected) }
    end
  end

  describe '#resource_path' do
    context 'for resource' do
      subject { klass.resource_path(:shipments) }

      let(:expected) { 'some_account/api/shipments' }

      it { is_expected.to eq(expected) }

      context 'by id' do
        subject { klass.resource_path(:shipments, id: 11) }

        let(:expected) { 'some_account/api/shipments/11' }

        it { is_expected.to eq(expected) }

        context 'with action' do
          subject { klass.resource_path(:shipments, id: 11, action: :pack) }

          let(:expected) { 'some_account/api/shipments/11/pack' }

          it { is_expected.to eq(expected) }
        end
      end
    end

    context 'overriding account' do
      subject { klass.resource_path(:shipments, account: 'other_account') }

      let(:expected) { 'other_account/api/shipments' }

      it { is_expected.to eq(expected) }
    end
  end
end
