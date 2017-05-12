class TokensController < ApplicationController
  before_action :set_token, only: [:show, :edit, :update, :destroy]

  # GET /tokens
  def index
    @tokens = Token.order(created_at: :desc)
  end

  # GET /tokens/1
  def show
  end

  # GET /tokens/new
  def new
    @token = Token.new
  end

  # GET /tokens/1/edit
  def edit
  end

  # POST /tokens
  def create
    @token = Token.new(token_params)

    if @token.save
      token =  ProvisionToken.call(token: @token, client_pub: @token.client_pub_key)

      # mail token (encrypted)

      redirect_to @token, notice: 'Encrypted token and sent.'
    else
      render :new
    end
  end

  # PATCH/PUT /tokens/1
  def update
    if @token.update(token_params)
      redirect_to @token, notice: 'Token was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /tokens/1
  def destroy
    @token.destroy
    redirect_to tokens_url, notice: 'Token was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_token
      @token = Token.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def token_params
      params.require(:token).permit(
        :requested_by,
        :client_name,
        :api_env,
        :contact_email,
        :revoked
      )
    end
end
