class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :setup_required_vars

  def current_user
    # TODO: in a real application lookup User record from session['sso_id']
    if session['sso_user']
      @user ||= User.from_moj_signon_data(session['sso_user'])
    end
  end

  private

    def authenticate_user
      unless current_user
        session[:redirect_path] = request.original_fullpath
        redirect_to '/auth/auth0'
      end
    end

    def setup_required_vars
      @scripts = []
    end
end
