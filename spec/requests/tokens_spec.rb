require 'rails_helper'

RSpec.describe "Tokens", type: :request do
  describe "GET /admin/tokens" do
    it "forces a login" do
      get admin_tokens_path
      expect(response).to have_http_status(302)
    end
  end
end
