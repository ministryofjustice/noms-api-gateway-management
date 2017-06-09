require 'rails_helper'

RSpec.describe Notify do
  before do
    allow(Notify).to receive(:service_team).with(access_request, access_request_link).and_return('06f063d1-776d-48ed-9253-6a32c443fcce')
  end

  describe '#service_team' do
    let(:access_request) { create(:access_request) }
    let(:access_request_link) { "http://localhost:3000/access_requests/#{access_request.id}" }

    it 'sends a request to GOV UK Notify and returns the notification id' do
      expect(Notify.service_team(access_request, access_request_link)).to eq('06f063d1-776d-48ed-9253-6a32c443fcce')
    end
  end
end
