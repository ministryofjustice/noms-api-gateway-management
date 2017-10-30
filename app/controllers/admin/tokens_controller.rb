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

      [:requested_by, :contact_email, :environment_id, :service_name, :client_pub_key].each do |variable|
        eval("@token.#{variable} = @access_request.#{variable}")
      end
    end
  end

  # POST /tokens
  def create
    @token = Token.new(token_params)
    # Explicitly set this here, rather than allow it to be passed in,
    # as if this value is not 'web', some validations are bypassed
    # to allow import of incomplete data from old spreadsheet
    @token.created_from = 'web'
    @access_request = AccessRequest.find(params[:access_request_id]) rescue nil

    if @token.save
      @access_request.process! if @access_request

      if Rails.configuration.notify_enabled
        Notify.token_trackback(@token, new_token_url(trackback_token: @token.trackback_token))
        redirect_to admin_tokens_url, notice: 'Token creation link sent.'
      else
        redirect_to admin_tokens_url, notice: 'Token creation link sent: ' + new_token_url(trackback_token: @token.trackback_token)
      end

    else
      render :new
    end
  end

  # PATCH/PUT /tokens/1
  def revoke
    @token.revoke!
    Notify.revoke_token(@token) if Rails.configuration.notify_enabled 
    redirect_to admin_tokens_url, notice: 'Token was successfully revoked.'
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
        :environment_id,
        :contact_email,
        :permissions,
        :client_pub_key,
        :client_pub_key_file,
        :expires
      )
    end
end
