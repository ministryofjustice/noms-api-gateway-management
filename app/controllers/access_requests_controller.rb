class AccessRequestsController < ApplicationController
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
      Notify.service_team(@access_request, admin_access_request_url(@access_request))

      redirect_to @access_request, notice: 'Access request was successfully created.'
    else
      render :new
    end
  end

  private
    # Only allow a trusted parameter "white list" through.
    def access_request_params
      params.require(:access_request).permit(
        :contact_email,
        :requested_by,
        :service_name,
        :reason,
        :api_env,
        :client_pub_key_file,
        :pgp_key_file
      )
    end
end
