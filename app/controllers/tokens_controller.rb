class TokensController < ApplicationController
  before_action :set_token, only: [:new, :update]

  # GET /tokens/new
  def new
    @team_email = set_team_email
    @parsed_permissions = set_parsed_permissions
  end

  # PATCH/PUT /tokens/1
  def update
    begin
      payload = @token.provision_and_activate!
      filename = "nomis-api_#{@token.service_name.downcase.underscore}_#{@token.environment.name}.token"
      send_data(payload, type: 'text/plain', disposition: 'attachment', filename: filename)
    rescue
      redirect_to new_token_url(trackback_token: params[:trackback_token]),
        alert: 'Unable to provision token. Please contact team.'
    end
  end

  private

  def set_token
    @token = Token.find_by(trackback_token: params[:trackback_token])
    raise ActionController::RoutingError.new('Not Found') if params[:trackback_token].blank? || @token.nil?
  end

  def set_team_email
    ENV['TEAM_EMAIL'] || 'nomisapi@digital.justice.gov.uk'
  end

  def set_parsed_permissions
    @token.permissions.split.map { |p| Regexp.new(p).inspect }
  end
end
