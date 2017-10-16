require 'rails_helper'

RSpec.describe NomisApiClient do

  let(:health_ok_raw)   { double 'raw_response',    code: '200' }
  let(:health_ok)       { double 'parsed-response', raw_response: health_ok_raw, data: 'DB Up' }
  let(:health_bad_raw)  { double 'raw_response',    code: '403' }
  let(:health_bad)      { double 'parsed-response', raw_response: health_bad_raw, data: nil }

  let(:version_ok_raw)  { double 'raw_response',    code: '200' }
  let(:version_data)    { { 'api-version' => '1.16.1', 'build-timestamp' => '2017-09-20 12:30:06' } }
  let(:version_ok)      { double 'parsed-response', raw_response: version_ok_raw, data: version_data }
  let(:version_bad_raw) { double 'raw_response',    code: '403' }
  let(:version_bad)     { double 'parsed-response', raw_response: version_bad_raw, data: "not a hash" }

  let(:api_client)      { double 'NOMIS::API::Get', execute: version_ok }

  let(:response_parser) { ExceptionSafeResponseParser.new          }
  let(:env)             { create(:environment)                     }
  let(:subject)         { NomisApiClient.new(env, response_parser) }

  describe '#env_name' do
    it 'returns the name of the corresponding environment' do
      expect(subject.env_name).to eq env.name
    end
  end

  describe '#client_key' do
    it 'returns the corresponding environment client_private_key' do
      expect(subject.client_key).to eq env.client_private_key
    end
  end

  describe '#client_token' do
    it 'returns the corresponding environment json web token' do
      expect(subject.client_token).to eq env.jwt
    end 
  end

  describe '#get_health' do
    context 'when the environment is UP' do
      it 'returns "DB Up"' do
        allow(NOMIS::API::Get).to receive(:new).and_return(api_client)
        allow(api_client).to receive(:execute).and_return(health_ok)
        expect(subject.get_health).to eq '200: DB Up'
      end
    end

    context 'when the environment is DOWN' do
      it 'returns a message containing the error code' do
        allow(NOMIS::API::Get).to receive(:new).and_return(api_client)
        allow(api_client).to receive(:execute).and_return(health_bad)
        expect(subject.get_health).to eq '403'
      end
    end
  end

  describe '#get_version' do
    context 'when the environment is UP' do
      it 'returns version number of the deployed application' do
        allow(subject).to receive(:get).with('version').and_return(version_ok)
        expect(subject.get_version).to eq '1.16.1'
      end
    end

    context 'when the environment is DOWN' do
      it 'returns nil' do
        allow(subject).to receive(:get).with('version').and_return(version_bad)
        expect(subject.get_version).to eq nil
      end
    end
  end

  describe '#get_version_timestamp' do
    context 'when the environment is UP' do
      it 'return the build timestamp' do
        allow(subject).to receive(:get).with('version').and_return(version_ok)
        expect(subject.get_version_timestamp).to eq '2017-09-20 12:30:06'
      end
    end

    context 'when the environment is DOWN' do
      it 'returns nil' do
        allow(subject).to receive(:get).with('version').and_return(version_bad)
        expect(subject.get_version_timestamp).to eq nil
      end
    end
  end

  describe '#get' do 
    it 'delegates to NOMIS::API::Get (gem)' do
      expect(NOMIS::API::Get).to receive(:new).with(
        client_key: subject.client_key,
        client_token: subject.client_token,
        base_url: subject.base_url,
        path: 'version'
      ).and_return(api_client)
      subject.get('version')
    end

    context 'when the environment is not yet live' do
      let(:response_code){ subject.get('health').code }

      it 'handles the error and returns a 404' do
        allow(NOMIS::API::Get).to receive(:new).with(
          client_key: subject.client_key,
          client_token: subject.client_token,
          base_url: subject.base_url,
          path: 'health'
        ).and_return(api_client)
        allow(api_client).to receive(:execute).and_raise(SocketError)
        puts "EXPECTED ERROR FOR TESTING ERROR HANDLING - please ignore"
        expect(response_code).to eq 404
        puts "^ /EXPECTED ERROR FOR TESTING ERROR HANDLING - please ignore"
      end
    end
  end
end
