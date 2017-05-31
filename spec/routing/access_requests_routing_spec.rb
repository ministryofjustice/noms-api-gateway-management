require "rails_helper"

RSpec.describe AccessRequestsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/access_requests").to route_to("access_requests#index")
    end

    it "routes to #new" do
      expect(:get => "/access_requests/new").to route_to("access_requests#new")
    end

    it "routes to #show" do
      expect(:get => "/access_requests/1").to route_to("access_requests#show", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/access_requests").to route_to("access_requests#create")
    end

    it "routes to #destroy" do
      expect(:delete => "/access_requests/1").to route_to("access_requests#destroy", :id => "1")
    end

  end
end
