require "rails_helper"

RSpec.describe Api::TokensController, type: :routing do
  describe "routing" do
    it "routes to #revoked" do
      expect(:get => "/api/tokens/revoked").to route_to("api/tokens#revoked")
    end
  end
end
