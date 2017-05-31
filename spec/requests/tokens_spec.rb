require 'rails_helper'

RSpec.describe "Tokens", type: :request do
  describe "GET /admin/tokens" do
    it "gets the admin tokens page" do
      get admin_tokens_path
      expect(response).to have_http_status(200)
    end
  end
end
