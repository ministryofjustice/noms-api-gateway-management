require "rails_helper"

RSpec.describe TokensController, type: :routing do
  describe "routing" do
    it "routes to #new with a valid trackback token" do
      create(:token, trackback_token: '123xxx')
      expect(:get => "/tokens/new", params: { id: '123xxx' }).to route_to("tokens#new")
    end

    it "routes to #update via PUT" do
      expect(:put => "/tokens/1").to route_to("tokens#update", :id => "1")
    end

    it "routes to #revoke via PATCH" do
      expect(:patch => "/tokens/1").to route_to("tokens#update", :id => "1")
    end
  end
end
