require 'rails_helper'

RSpec.describe TokensController, type: :controller do
  let(:token) { create(:token, permissions: "^\\/nomisapi\\/foo$\n^\\/nomisapi\\/bar$\r\n^\\/nomisapi\\/baz$") }

  describe "GET #new" do
    context 'with a valid trackback token' do
      it "returns http success" do
        get :new, params: { trackback_token: token.trackback_token }
        expect(response).to have_http_status(:success)
      end

      it "assigns @team_email" do
        get :new, params: { trackback_token: token.trackback_token }
        expect(assigns(:team_email)).not_to be_nil
      end

      it 'assigns @parsed_permissions' do
        get :new, params: { trackback_token: token.trackback_token }
        expect(assigns(:parsed_permissions)).to eq [
            "/^\\/nomisapi\\/foo$/",
            "/^\\/nomisapi\\/bar$/",
            "/^\\/nomisapi\\/baz$/"
          ]
      end
    end

    context 'without a valid trackback token' do
      it "raises 404" do
        expect{ get :new, params: { trackback_token: 'xxxx' } }.
          to raise_exception(ActionController::RoutingError)
      end
    end

    context 'with no trackback token, when a token without a trackback_token exists' do
      before { create(:token, trackback_token: nil) }
      it "raises 404" do
        expect{ get :new }.to raise_exception(ActionController::RoutingError)
      end
    end
  end

  describe "PATCH/PUT #update" do
    context 'non valid trackback token' do
      it 'raises 404' do
        expect{ patch :update, params: { id: token, trackback_token: '123xxx' } }.
          to raise_exception(ActionController::RoutingError)
      end
    end

    context 'valid trackback token' do
      before do
        patch :update, params: { id: token, trackback_token: token.trackback_token }
        token.reload
      end

      it 'sets the token active' do
        expect(token).to be_active
      end

      it 'sets the trackback_token to nil' do
        expect(token.trackback_token).to be_nil
      end

      it 'returns the provisioned token' do
        expect(response.body).to_not be_nil
      end
    end
  end
end
