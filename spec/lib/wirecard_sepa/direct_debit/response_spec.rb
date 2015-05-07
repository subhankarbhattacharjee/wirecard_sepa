require 'spec_helper'

describe WirecardSepa::DirectDebit::Response do
  let(:success_xml) { read_support_file('direct_debit/success/response.xml') }
  let(:failure_xml) { read_support_file('direct_debit/failure/response.xml') }

  let(:success_response) { described_class.new success_xml }
  let(:failure_response) { described_class.new failure_xml }

  describe '.for_request(request)' do
    let(:request) { double('Fake Typhoeus request', body: '</xml>') }
    let(:response) { described_class.for_request(request) }

    it 'takes a uses the requests body to create a response' do
      expect(response.xml).to eq '</xml>'
    end

    it 'stores the request object for debugging cases' do
      expect(response.request).to eq request
    end
  end

  describe '#params' do
    context 'for a successful response' do
      let(:params) { success_response.params }

      it('params[:transaction_id]')     { expect(params[:transaction_id]).to eq '3971c2d8-250f-11e3-8d4b-005056a97162' }
      it('params[:transaction_state]')  { expect(params[:transaction_state]).to eq 'success' }
      it('params[:status_code]')        { expect(params[:status_code]).to eq '201.0000' }
      it('params[:status_description]') { expect(params[:status_description]).to eq 'The resource was successfully created.' }
      it('params[:due_date]')           { expect(params[:due_date]).to eq '2013-10-03' }
      it('params[:reference_id]')       { expect(params[:reference_id]).to eq '33F7A4D125' }
    end
  end

  describe '#success?' do
    it 'returns true for a succesful response' do
      expect(success_response.success?).to eq true
    end

    it 'returns false for a failure response' do
      expect(failure_response.success?).to eq false
    end
  end
end
