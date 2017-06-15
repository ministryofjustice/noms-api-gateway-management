class SessionsController < ApplicationController
  def create
    auth_data = request.env['omniauth.auth']
    
    session[:sso_id] = auth_data.fetch('uid')
    session[:sso_user] = auth_data.fetch('info')
    
    redirect_to session.delete(:redirect_path) || root_path
  end

  def destroy
    if current_user
      sso_logout_url = current_user.links['logout']
      session.delete(:sso_id)
      session.delete(:sso_user)
      redirect_to logout_url(sso_logout_url, redirect_to: root_url)
    else
      redirect_to root_url
    end
  end
  
  private
  
  def logout_url(sso_logout_url, redirect_to: nil)
    url = URI.parse(sso_logout_url)
    url.query = { redirect_to: redirect_to }.to_query if redirect_to
    url.to_s
  end
end