require "rails_helper"

RSpec.describe Admin::AccessRequestsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(get: "/admin/access_requests").to route_to("admin/access_requests#index")
    end

    it "routes to #show" do
      expect(get: "/admin/access_requests/1").to route_to("admin/access_requests#show", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/admin/access_requests/1").to route_to("admin/access_requests#destroy", id: "1")
    end
  end
end
