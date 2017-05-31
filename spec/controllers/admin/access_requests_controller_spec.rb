require 'rails_helper'

RSpec.describe Admin::AccessRequestsController, type: :controller do
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # Admin::AccessRequestsController. Be sure to keep this updated too.

  let(:valid_session) { {} }

  let(:access_request) { create(:access_request) }

  describe "GET #index" do
    it "assigns all access_requests as @access_requests" do
      get :index, params: {}, session: valid_session
      expect(assigns(:access_requests)).to eq([access_request])
    end
  end

  describe "GET #show" do
    it "assigns the requested access_request as @access_request" do
      get :show, params: {id: access_request.to_param}, session: valid_session
      expect(assigns(:access_request)).to eq(access_request)
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested access_request" do
      access_request

      expect {
        delete :destroy, params: {id: access_request.to_param}, session: valid_session
      }.to change(AccessRequest, :count).by(-1)
    end

    it "redirects to the access_requests list" do
      delete :destroy, params: {id: access_request.to_param}, session: valid_session
      expect(response).to redirect_to(admin_access_requests_url)
    end
  end
end
