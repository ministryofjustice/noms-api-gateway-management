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
  let(:client_pub_key) { fixture_file_upload('test_client.pub', 'text/plain') }

  # This should return the minimal set of attributes required to create a valid
  # Token. As you add validations to Token, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {
      requested_by: 'John Smith',
      client_name: 'xxx',
      api_env: 'prod',
      contact_email: 'email@example.com',
      client_pub_key: client_pub_key,
      expires: 1.year.from_now
    }
  }

  let(:invalid_attributes) {
    {
      requested_by: 'John Smith',
      client_name: 'xxx',
      api_env: 'foobar',
      contact_email: 'email@example.com'
    }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # TokensController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  let(:test_provisioner_key) { fixture_file_upload('test_provisioner.key', 'text/plain') }

  before do
    allow(RetrieveKey).to receive(:call).with('prod').and_return(test_provisioner_key.read)
    allow(RetrieveKey).to receive(:call).with('foobar').and_raise(ArgumentError)
  end

  describe "GET #index" do
    let(:token) { create(:token) }

    it "assigns all tokens as @tokens" do
      get :index, params: {}, session: valid_session
      expect(assigns(:tokens)).to eq([token])
    end
  end

  describe "GET #show" do
    let(:token) { create(:token) }

    it "assigns the requested token as @token" do
      get :show, params: {id: token.to_param}, session: valid_session
      expect(assigns(:token)).to eq(token)
    end
  end

  describe "GET #new" do
    it "assigns a new token as @token" do
      get :new, params: {}, session: valid_session
      expect(assigns(:token)).to be_a_new(Token)
    end
  end

  describe "GET #edit" do
    let(:token) { create(:token) }

    it "assigns the requested token as @token" do
      get :edit, params: {id: token.to_param}, session: valid_session
      expect(assigns(:token)).to eq(token)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Token" do
        expect {
          post :create, params: {token: valid_attributes}, session: valid_session
        }.to change(Token, :count).by(1)
      end

      it "assigns a newly created token as @token" do
        post :create, params: {token: valid_attributes}, session: valid_session
        expect(assigns(:token)).to be_a(Token)
        expect(assigns(:token)).to be_persisted
      end

      it "redirects to the created token" do
        post :create, params: {token: valid_attributes}, session: valid_session
        expect(response).to redirect_to([:admin, Token.last])
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved token as @token" do
        post :create, params: {token: invalid_attributes}, session: valid_session
        expect(assigns(:token)).to be_a_new(Token)
      end

      it "re-renders the 'new' template" do
        post :create, params: {token: invalid_attributes}, session: valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    let(:token) { create(:token) }

    context "with valid params" do
      let(:new_attributes) {
        {
          api_env: 'preprod'
        }
      }

      it "updates the requested token" do
        put :update, params: {id: token.to_param, token: new_attributes}, session: valid_session
        token.reload
        expect(token.api_env).to eq('preprod')
      end

      it "assigns the requested token as @token" do
        put :update, params: {id: token.to_param, token: valid_attributes}, session: valid_session
        expect(assigns(:token)).to eq(token)
      end

      it "redirects to the token" do
        put :update, params: {id: token.to_param, token: valid_attributes}, session: valid_session
        expect(response).to redirect_to([:admin, token])
      end
    end

    context "with invalid params" do
      it "assigns the token as @token" do
        put :update, params: {id: token.to_param, token: invalid_attributes}, session: valid_session
        expect(assigns(:token)).to eq(token)
      end

      it "re-renders the 'edit' template" do
        put :update, params: {id: token.to_param, token: invalid_attributes}, session: valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:token) { create(:token) }

    it "destroys the requested token" do
      expect {
        delete :destroy, params: {id: token.to_param}, session: valid_session
      }.to change(Token, :count).by(-1)
    end

    it "redirects to the tokens list" do
      delete :destroy, params: {id: token.to_param}, session: valid_session
      expect(response).to redirect_to(admin_tokens_url)
    end
  end

end