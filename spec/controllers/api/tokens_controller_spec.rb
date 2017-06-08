require 'rails_helper'

RSpec.describe Api::TokensController, type: :controller do
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # TokensController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe '#revoked' do
    let(:token_1) { create(:token) }
    let(:token_2) { create(:token) }
    let(:token_3) { create(:token) }

    it 'returns a list of the fingerprints of the revoked tokens' do
      token_1.revoke!
      token_3.revoke!

      get :revoked, params: {}, session: valid_session
      expect(JSON.parse(response.body)).to eq([token_1.fingerprint, token_3.fingerprint])
    end
  end
end
