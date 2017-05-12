class AccessRequestsController < ApplicationController
  before_action :set_access_request, only: [:show, :edit, :update, :destroy]

  # GET /access_requests
  def index
    @access_requests = AccessRequest.all
  end

  # GET /access_requests/1
  def show
  end

  # GET /access_requests/new
  def new
    @access_request = AccessRequest.new
  end

  # GET /access_requests/1/edit
  def edit
  end

  # POST /access_requests
  def create
    @access_request = AccessRequest.new(access_request_params)

    if @access_request.save
      redirect_to @access_request, notice: 'Access request was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /access_requests/1
  def update
    if @access_request.update(access_request_params)
      redirect_to @access_request, notice: 'Access request was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /access_requests/1
  def destroy
    @access_request.destroy
    redirect_to access_requests_url, notice: 'Access request was successfully destroyed.'
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
