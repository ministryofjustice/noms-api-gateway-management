require 'spec_helper'

RSpec.describe ExceptionSafeResponse do

  let(:raw)          { double 'RawData', code: '200'                          }
  let(:api_response) { double 'ApiResponse', raw_response: raw, data: 'DB Up' }

  let(:success_subject)   { ExceptionSafeResponse.new(api_response)    }
  let(:exception_subject) { ExceptionSafeResponse.new(SocketError.new) }

  describe '#new' do
    context 'when initialized with an suceessful api_response' do
      it 'returns an object that responds to #code with 200' do
        expect(success_subject.code).to eq 200
      end

      it 'returns an object that responds to #data' do
        expect(success_subject.data).to eq 'DB Up'
      end
    end

    context 'when initialized with a SocketError' do
      it 'returns an object that responds to #code with 404' do
        expect(exception_subject.code).to eq 404
      end

      it 'returns an object that responds to #data' do
        expect(exception_subject.data).to eq 'Environment does not exist'
      end
    end
  end
end
