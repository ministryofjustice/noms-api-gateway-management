require 'rails_helper'

RSpec.describe Api::TokensController, type: :controller do
  before do
    ENV['API_AUTH'] = 'foobar123'
  end

  describe '#revoked' do
    context 'when auth header provided' do
      let(:token_1) { create(:token) }
      let(:token_2) { create(:token) }
      let(:token_3) { create(:token) }

      it 'returns a list of the fingerprints of the revoked tokens' do
        token_1.revoke!
        token_3.revoke!

        request.headers['Authorization'] = 'foobar123'
        get :revoked, params: {}
        expect(JSON.parse(response.body)).to eq([token_1.fingerprint, token_3.fingerprint])
      end
    end

    context 'when auth header not provided' do
      before { get :revoked, params: {} }

      it 'renders json error' do
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Unauthorised' })
      end

      it 'returns 403' do
        expect(response.status).to eq(403)
      end
    end
  end
end
