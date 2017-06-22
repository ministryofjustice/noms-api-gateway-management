require 'rails_helper'

RSpec.describe Admin::ProvisioningKeysController, type: :controller do
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # Admin::AccessRequestsController. Be sure to keep this updated too.

  let(:empty_session){ {} }
  let(:valid_session){ {'sso_user' => {}} }
  let(:admin_session){ {'sso_user' => {'permissions'=> [{'roles' => [ 'admin' ]}]}}}

  let(:provisioning_key_1) { create(:provisioning_key) }

  # This should return the minimal set of attributes required to create a valid
  # Token. As you add validations to Token, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {
      api_env: 'dev',
      content: file_fixture('test_provisioner.key').read
    }
  }

  let(:invalid_attributes) {
    {
      api_env: 'foobar',
      content: file_fixture('test_provisioner.key').read
    }
  }

  let(:bad_key) {
    {
      api_env: 'foobar',
      content: 'abcd1234'
    }
  }

  context 'when not logged in' do
    let(:session){ empty_session }

    describe "GET #index" do
      it "redirects to /auth/mojsso" do
        get :index, params: {}, session: session
        expect( response ).to redirect_to '/auth/mojsso'
      end
    end

    describe "GET #new" do
      it "redirects to /auth/mojsso" do
        get :new, params: {}, session: session
        expect( response ).to redirect_to '/auth/mojsso'
      end
    end

    describe "GET #show" do
      it "redirects to /auth/mojsso" do
        get :show, params: {id: provisioning_key_1.to_param}, session: session
        expect( response ).to redirect_to '/auth/mojsso'
      end
    end

    describe "POST create" do
      it "redirects to /auth/mojsso" do
        post :create, params: {provisioning_key: valid_attributes}, session: session
        expect( response ).to redirect_to '/auth/mojsso'
      end
    end
  end

  context 'when logged in' do
    context 'as a user without admin role' do
      let(:session){ valid_session }

      describe "GET #index" do
        it "responds with 403" do
          get :index, params: {}, session: session
          expect( response.status ).to eq(403)
        end
      end

      describe "GET #new" do
        it "responds with 403" do
          get :new, params: {}, session: session
          expect( response.status ).to eq(403)
        end
      end

      describe "GET #show" do
        it "responds with 403" do
          get :show, params: {id: provisioning_key_1.to_param}, session: session
          expect( response.status ).to eq(403)
        end
      end

      describe "POST create" do
        it "responds with 403" do
          post :create, params: {provisioning_key: valid_attributes}, session: session
          expect( response.status ).to eq(403)
        end
      end
    end

    context 'as a user with admin role' do
      let(:session){ admin_session }

      describe "GET #index" do
        it "assigns all provisioning keys to @provisioning_keys" do
          get :index, params: {}, session: session
          expect(assigns(:provisioning_keys)).to eq([provisioning_key_1])
        end
      end

      describe "GET #new" do
        it "assigns a new provisioning_key to @provisioning_key" do
          get :new, params: {}, session: session
          expect(assigns(:provisioning_key)).to be_a_new(ProvisioningKey)
        end
      end

      describe "GET #show" do
        it "assigns the requested token as @token" do
          get :show, params: {id: provisioning_key_1.to_param}, session: session
          expect(assigns(:provisioning_key)).to eq(provisioning_key_1)
        end
      end

      describe "DELETE #destroy" do
        it "destroys the requested provisioning_key" do
          post :create, params: {provisioning_key: valid_attributes}, session: session
          expect(ProvisioningKey.count).to be(1)
          provisioning_key_2 = assigns(:provisioning_key)
          delete :destroy, params: {id: provisioning_key_2.to_param}, session: session
          expect(ProvisioningKey.count).to be(0)
        end

        it "redirects to the provisioning_key list" do
          delete :destroy, params: {id: provisioning_key_1.to_param}, session: session
          expect(response).to redirect_to(admin_provisioning_keys_url)
        end
      end

      context "with valid params" do
        it "creates a new ProvisioningKey" do
          expect {
            post :create, params: {provisioning_key: valid_attributes}, session: session
          }.to change(ProvisioningKey, :count).by(1)
        end

        it "assigns a newly created provisioning_key as @provisioning_key and persists it" do
          post :create, params: {provisioning_key: valid_attributes}, session: session
          expect(assigns(:provisioning_key)).to be_a(ProvisioningKey)
          expect(assigns(:provisioning_key)).to be_persisted
        end

        it "redirects to the created provisioning_key" do
          post :create, params: {provisioning_key: valid_attributes}, session: session
          expect(response).to redirect_to(admin_provisioning_key_url(assigns(:provisioning_key)))
        end
      end

      context "with invalid params" do
        it "assigns a newly created but unsaved provisioning_key as @provisioning_key" do
          post :create, params: {provisioning_key: invalid_attributes}, session: session
          expect(assigns(:provisioning_key)).to be_a_new(ProvisioningKey)
        end

        it "re-renders the 'new' template" do
          post :create, params: {provisioning_key: invalid_attributes}, session: session
          expect(response).to render_template("new")
        end
      end

    end

  end

end
