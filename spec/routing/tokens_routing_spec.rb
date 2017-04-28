require "rails_helper"

RSpec.describe TokensController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/tokens").to route_to("tokens#index")
    end

    it "routes to #new" do
      expect(:get => "/tokens/new").to route_to("tokens#new")
    end

    it "routes to #show" do
      expect(:get => "/tokens/1").to route_to("tokens#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/tokens/1/edit").to route_to("tokens#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/tokens").to route_to("tokens#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/tokens/1").to route_to("tokens#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/tokens/1").to route_to("tokens#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/tokens/1").to route_to("tokens#destroy", :id => "1")
    end

  end
end
