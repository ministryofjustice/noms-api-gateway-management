class Admin::AccessRequestsController < Admin::AdminController
  before_action :set_access_request, only: [:show, :edit, :update, :destroy]

  # GET /access_requests
  def index
    @access_requests = AccessRequest.order(created_at: :desc)
  end

  # GET /access_requests/1
  def show
  end

  # DELETE /access_requests/1
  def destroy
    @access_request.destroy
    redirect_to admin_access_requests_url, notice: 'Access request was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_access_request
      @access_request = AccessRequest.find(params[:id])
    end
end
