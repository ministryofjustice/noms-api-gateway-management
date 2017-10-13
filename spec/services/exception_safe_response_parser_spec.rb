require 'rails_helper'

RSpec.describe ExceptionSafeResponseParser do

  let(:raw)          { double 'RawData', code: '200'                          }
  let(:api_response) { double 'ApiResponse', raw_response: raw, data: 'DB Up' }


  describe '#parse' do
    context 'when called with a suceessful api_response' do

      let(:parsed_response) { subject.parse(api_response) }

      it 'returns an object that responds to #code with 200' do
        expect(parsed_response.code).to eq 200
      end

      it 'returns an object that responds to #data' do
        expect(parsed_response.data).to eq '200: DB Up'
      end
    end

    context 'when called with a SocketError' do

      let(:parsed_response) { subject.parse(SocketError.new) }

      it 'returns an object that responds to #code with 404' do
        expect(parsed_response.code).to eq 404
      end

      it 'returns an object that responds to #data' do
        expect(parsed_response.data).to eq 'Environment does not exist'
      end
    end
  end
end
