class Api::TokensController < Api::ApiController
  def revoked
    @tokens = Token.revoked.order(created_at: :asc)
    render json: @tokens.pluck(:fingerprint)
  end
end
