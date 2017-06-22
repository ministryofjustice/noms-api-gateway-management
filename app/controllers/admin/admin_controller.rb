require 'custom_exceptions'

class Admin::AdminController < ApplicationController
  before_action :authenticate!, :ensure_admin! if Rails.configuration.auth_enabled

  rescue_from Auth::NotAuthorized, with: :not_authorized
  rescue_from Auth::NotLoggedIn, with: :login_required

  protected

  def authenticate!
    raise Auth::NotLoggedIn.new('You must be logged in to access this page') unless current_user
  end

  def ensure_admin!
    raise Auth::NotAuthorized.new('You must be an admin user') unless current_user && current_user.admin?
  end

  def not_authorized
    render plain: 'You are not authorized to do that', status: 403 and return
  end

  def login_required
    authenticate_user
  end
end
