require 'rails_helper'

RSpec.describe Admin::AccessRequestsController, type: :controller do
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # Admin::AccessRequestsController. Be sure to keep this updated too.

  let(:empty_session){ {} }
  let(:valid_session){ {'sso_user' => {}} }
  let(:admin_session){ {'sso_user' => {'permissions'=> [{'roles' => [ 'admin' ]}]}}}

  let(:access_request) { create(:access_request) }

  context 'when not logged in' do
    let(:session){ empty_session }

    describe "GET #index" do
      it "redirects to /auth/mojsso" do
        get :index, params: {}, session: session
        expect( response ).to redirect_to '/auth/mojsso'
      end
    end

    describe "GET #show" do
      it "redirects to /auth/mojsso" do
        get :show, params: {id: access_request.to_param}, session: session
        expect( response ).to redirect_to '/auth/mojsso'
      end
    end

    describe "DELETE #destroy" do
      it "redirects to /auth/mojsso" do
        delete :destroy, params: {id: access_request}, session: session
        expect( response ).to redirect_to '/auth/mojsso'
      end
    end
  end

  context "logged in" do
    context 'as a user without admin role' do
      let(:session){ valid_session }

      describe "GET #index" do
        it "responds with 403" do
          get :index, params: {}, session: session
          expect( response.status ).to eq(403)
        end
      end

      describe "GET #show" do
        it "responds with 403" do
          get :show, params: {id: access_request.to_param}, session: session
          expect( response.status ).to eq(403)
        end
      end

      describe "DELETE #destroy" do
        it "responds with 403" do
          delete :destroy, params: {id: access_request}, session: session
          expect( response.status ).to eq(403)
        end
      end
    end

    context 'as a user with admin role' do
      let(:session){ admin_session }

      describe "GET #index" do
        it "assigns all access_requests as @access_requests" do
          get :index, params: {}, session: session
          expect(assigns(:access_requests)).to eq([access_request])
        end
      end

      describe "GET #show" do
        it "assigns the requested access_request as @access_request" do
          get :show, params: {id: access_request.to_param}, session: session
          expect(assigns(:access_request)).to eq(access_request)
        end
      end

      describe "DELETE #destroy" do
        before do
          response = double(id: 'f23caa')
          allow(Notify).to receive(:reject_access_request).and_return(response)
        end

        it "destroys the requested access_request" do
          access_request

          expect {
            delete :destroy, params: {id: access_request.to_param}, session: session
          }.to change(AccessRequest, :count).by(-1)
        end

        it "redirects to the access_requests list" do
          delete :destroy, params: {id: access_request.to_param}, session: session
          expect(response).to redirect_to(admin_access_requests_url)
        end
      end
    end
  end
end
