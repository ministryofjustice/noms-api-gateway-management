require 'rails_helper'

RSpec.describe Notify do
  describe '#service_team' do
    let(:access_request) { create(:access_request) }
    let(:access_request_link) { "http://localhost:3000/access_requests/#{access_request.id}" }

    before do
      allow(Notify).to receive(:service_team).with(access_request, access_request_link).and_return('06f063d1-776d-48ed-9253-6a32c443fcce')
    end

    it 'sends a request to GOV UK Notify and returns the notification id' do
      expect(Notify.service_team(access_request, access_request_link)).to eq('06f063d1-776d-48ed-9253-6a32c443fcce')
    end
  end

  describe '#token_trackback' do
    let(:token) { create(:token) }
    let(:trackback_token) { "http://localhost:3000/tokens/new?trackback_token=#{token.trackback_token}" }

    before do
      allow(Notify).to receive(:token_trackback).with(token, trackback_token).and_return('96f063d1-996d-43ed-9253-6a32c423faaf')
    end

    it 'sends a request to GOV UK Notify and returns the notification id' do
      expect(Notify.token_trackback(token, trackback_token)).to eq('96f063d1-996d-43ed-9253-6a32c423faaf')
    end
  end

  describe '#reject_access_request' do
    let(:access_request) { create(:access_request) }

    before do
      allow(Notify).to receive(:reject_access_request).with(access_request).and_return('36f043d1-956c-43ed-9253-6a32c423fbbf')
    end

    it 'sends a request to GOV UK Notify and returns the notification id' do
      expect(Notify.reject_access_request(access_request)).to eq('36f043d1-956c-43ed-9253-6a32c423fbbf')
    end
  end

  describe '#revoke_token' do
    let(:active_token) { create(:token, :active) }

    before do
      allow(Notify).to receive(:revoke_token).with(active_token).and_return('c7712773-8533-4d1c-997b-0e44469001ec')
    end

    it 'sends a request to GOV UK Notify and returns the notification id' do
      expect(Notify.revoke_token(active_token)).to eq('c7712773-8533-4d1c-997b-0e44469001ec')
    end
  end
end
