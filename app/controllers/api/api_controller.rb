class Api::ApiController < ApplicationController
  before_action :authenticate!

  protected

  def authenticate!
    raise 'Missing auth' if ENV['API_AUTH'].blank?

    auth = params[:auth] || request.headers['Authorization']

    if auth != ENV['API_AUTH']
      render json: { error: 'Unauthorised'  }, status: 403
    end
  end
end
