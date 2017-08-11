require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe Admin::TokensController, type: :controller do
  let(:client_pub_key_file) { fixture_file_upload('files/test_client.pub', 'text/plain') }

  # This should return the minimal set of attributes required to create a valid
  # Token. As you add validations to Token, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {
      requested_by: 'John Smith',
      service_name: 'xxx',
      environment_id: Environment.first.id,
      contact_email: 'email@example.com',
      client_pub_key_file: client_pub_key_file,
      expires: 1.year.from_now,
      permissions: '.*'
    }
  }

  let(:invalid_attributes) {
    {
      requested_by: 'John Smith',
      client_name: 'xxx',
      environment_id: Environment.first.id,
      contact_email: 'email@example.com'
    }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # TokensController. Be sure to keep this updated too.
  let(:empty_session){ {} }
  let(:valid_session){ {'sso_user' => {}} }
  let(:admin_session){ {'sso_user' => {'permissions'=> [{'roles' => [ 'admin' ]}]}}}


  before do
    Environment.create(name: 'preprod', provisioning_key: file_fixture('test_provisioner.key').read)
  end

  context 'when not logged in' do
    let(:session){ empty_session }

    describe "GET #index" do
      let(:token) { create(:token) }

      it "redirects to /auth/mojsso" do
        get :index, params: {}, session: session
        expect( response ).to redirect_to '/auth/mojsso'
      end
    end
    describe "GET #show" do
      let(:token) { create(:token) }

      it "redirects to /auth/mojsso" do
        get :show, params: {id: token.to_param}, session: session
        expect( response ).to redirect_to '/auth/mojsso'
      end
    end
    describe "GET #new" do
      it "redirects to /auth/mojsso" do
        get :new, params: {}, session: session
        expect( response ).to redirect_to '/auth/mojsso'
      end
    end

    describe "POST create" do
      it "redirects to /auth/mojsso" do
        post :create, params: {token: 'blagh'}, session: session
        expect( response ).to redirect_to '/auth/mojsso'
      end
    end

    describe "PUT #revoke" do
      let(:token) { create(:token) }

      it "redirects to /auth/mojsso" do
        put :revoke, params: {id: token.to_param}, session: session
        expect( response ).to redirect_to '/auth/mojsso'
      end
    end
  end

  context 'when logged in as a non-admin' do
    let(:session){ valid_session }

    describe "GET #index" do
      let(:token) { create(:token) }

      it "responds with 403" do
        get :index, params: {}, session: session
        expect( response.status ).to eq(403)
      end
    end
    describe "GET #show" do
      let(:token) { create(:token) }

      it "responds with 403" do
        get :show, params: {id: token.to_param}, session: session
        expect( response.status ).to eq(403)
      end
    end
    describe "GET #new" do
      it "responds with 403" do
        get :new, params: {}, session: session
        expect( response.status ).to eq(403)
      end
    end

    describe "POST create" do
      it "responds with 403" do
        post :create, params: {token: 'blagh'}, session: session
        expect( response.status ).to eq(403)
      end
    end

    describe "PUT #revoke" do
      let(:token) { create(:token) }

      it "responds with 403" do
        put :revoke, params: {id: token.to_param}, session: session
        expect( response.status ).to eq(403)
      end
    end
  end

  context "logged in as an admin" do
    let(:session){ admin_session }

    describe "GET #index" do
      let(:token) { create(:token) }

      it "assigns all tokens as @tokens" do
        get :index, params: {}, session: session
        expect(assigns(:tokens)).to eq([token])
      end
    end

    describe "GET #show" do
      let(:token) { create(:token) }

      it "assigns the requested token as @token" do
        get :show, params: {id: token.to_param}, session: session
        expect(assigns(:token)).to eq(token)
      end
    end

    describe "GET #new" do
      it "assigns a new token as @token" do
        get :new, params: {}, session: session
        expect(assigns(:token)).to be_a_new(Token)
      end
    end

    describe "POST #create" do
      before do
        response = double(id: 'f23caa')
        allow(Notify.client).to receive(:send_email).and_return(response)
      end

      context "with valid params" do
        it "creates a new Token" do
          expect {
            post :create, params: {token: valid_attributes}, session: session
          }.to change(Token, :count).by(1)
        end

        it "assigns a newly created token as @token" do
          post :create, params: {token: valid_attributes}, session: session
          expect(assigns(:token)).to be_a(Token)
          expect(assigns(:token)).to be_persisted
        end

        it "redirects to the created token" do
          post :create, params: {token: valid_attributes}, session: session
          expect(response).to redirect_to(admin_tokens_url)
        end
      end

      context "with invalid params" do
        it "assigns a newly created but unsaved token as @token" do
          post :create, params: {token: invalid_attributes}, session: session
          expect(assigns(:token)).to be_a_new(Token)
        end

        it "re-renders the 'new' template" do
          post :create, params: {token: invalid_attributes}, session: session
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT #revoke" do
      let(:token) { create(:token) }

      it "updates the requested token" do
        put :revoke, params: {id: token.to_param}, session: session
        token.reload
        expect(token).to be_revoked
      end

      it "assigns the requested token as @token" do
        put :revoke, params: {id: token.to_param}, session: session
        expect(assigns(:token)).to eq(token)
      end

      it "redirects to the admin tokens path" do
        put :revoke, params: {id: token.to_param}, session: session
        expect(response).to redirect_to(admin_tokens_url)
      end
    end
  end
end
