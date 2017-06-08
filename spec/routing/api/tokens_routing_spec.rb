require "rails_helper"

RSpec.describe Api::TokensController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/api/tokens").to route_to("api/tokens#index")
    end
  end
end
