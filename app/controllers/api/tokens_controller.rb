class Api::TokensController < Api::ApiController
  def index
    @tokens = Token.revoked.order(created_at: :asc)
    render json: @tokens.pluck(:fingerprint)
  end
end
