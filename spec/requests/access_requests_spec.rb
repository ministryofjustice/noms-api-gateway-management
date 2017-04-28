require 'rails_helper'

RSpec.describe "AccessRequests", type: :request do
  describe "GET /access_requests" do
    it "works! (now write some real specs)" do
      get access_requests_path
      expect(response).to have_http_status(200)
    end
  end
end
