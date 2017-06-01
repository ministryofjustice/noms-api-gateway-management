require "rails_helper"

RSpec.describe Admin::TokensController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/admin/tokens").to route_to("admin/tokens#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/tokens/new").to route_to("admin/tokens#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/tokens/1").to route_to("admin/tokens#show", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/tokens").to route_to("admin/tokens#create")
    end

    it "routes to #revoke via PUT" do
      expect(:put => "/admin/tokens/1/revoke").to route_to("admin/tokens#revoke", :id => "1")
    end

    it "routes to #revoke via PATCH" do
      expect(:patch => "/admin/tokens/1/revoke").to route_to("admin/tokens#revoke", :id => "1")
    end
  end
end
