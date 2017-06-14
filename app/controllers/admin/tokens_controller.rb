class Admin::TokensController < Admin::AdminController
  before_action :set_token, only: [:show, :edit, :revoke]

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

    if params[:access_request]
      @access_request = AccessRequest.find(params[:access_request])

      [:requested_by, :contact_email, :api_env, :service_name, :client_pub_key].each do |variable|
        eval("@token.#{variable} = @access_request.#{variable}")
      end
    end
  end

  # POST /tokens
  def create
    @token = Token.new(token_params)
    @token.client_pub_key = @token.client_pub_key_file.read if @token.client_pub_key_file.present?

    begin
      token = ProvisionToken.call(token: @token)
    rescue Exception => e
      @token.errors.add(:client_pub_key)
      render :new and return
    end

    if @token.save
      # mail token (encrypted)
      redirect_to [:admin, @token], notice: 'Encrypted token and sent.'
    else
      render :new
    end
  end

  # PATCH/PUT /tokens/1
  def revoke
    @token.revoke! and redirect_to admin_tokens_url, notice: 'Token was successfully revoked.'
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
        :service_name,
        :api_env,
        :contact_email,
        :revoked,
        :client_pub_key,
        :client_pub_key_file,
        :expires
      )
    end
end
