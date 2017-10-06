require 'spec_helper'

RSpec.describe ExceptionSafeResponseParser do

  let(:raw)          { double 'RawData', code: '200'                          }
  let(:api_response) { double 'ApiResponse', raw_response: raw, data: 'DB Up' }

  let(:subject)   { ExceptionSafeResponseParser.new }

  describe '#new' do
    it 'generates an OpenStruct called parsed_response on the new object' do
      expect(subject.parsed_response.to_s).to eq '#<OpenStruct code=nil, data=nil>'
    end
  end

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
