class AccessRequestsController < ApplicationController
  before_action :set_access_request, only: [:show]

  # GET /access_requests/1
  def show
  end

  # GET /access_requests/new
  def new
    @access_request = AccessRequest.new
  end

  # POST /access_requests
  def create
    @access_request = AccessRequest.new(access_request_params)

    if @access_request.save
      AccessRequestMailer.access_request_email(@access_request).deliver_later
      redirect_to @access_request, notice: 'Access request was successfully created.'
    else
      render :new
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_access_request
      @access_request = AccessRequest.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def access_request_params
      params.require(:access_request).permit(
        :email,
        :name,
        :app_name,
        :reason,
        :api_env,
        :client_pub_key_file,
        :pgp_key_file
      )
    end
end
