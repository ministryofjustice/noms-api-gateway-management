require 'rails_helper'

RSpec.describe "AccessRequests", type: :request do
  describe "GET /admin/access_requests" do
    it "redirects to the login page" do
      get admin_access_requests_path
      expect(response).to redirect_to('/auth/mojsso')
    end
  end

  describe "GET /admin/access_requests/1" do
    let(:access_request) { create(:access_request) }

    it "redirects to the login page" do
      get admin_access_request_path(access_request)
      expect(response).to redirect_to('/auth/mojsso')
    end
  end

  describe "GET /access_requests/1" do
    let(:access_request) { create(:access_request) }

    it "gets the access request" do
      get access_request_path(access_request)
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /access_requests/new" do
    let(:access_request) { create(:access_request) }

    it "gets the access request new page" do
      get new_access_request_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /" do
    let(:access_request) { create(:access_request) }

    it "gets the access request new page" do
      get new_access_request_path
      expect(response).to have_http_status(200)
    end
  end
end
