class AccessRequestFormThrottle < Rack::Throttle::Minute
  def allowed?(request)
    begin
      path_info = Rails.application.routes.recognize_path request.url || {}
    rescue
      path_info = {}
    end

    if path_info[:controller] == 'access_requests' && path_info[:action] == 'new'
      super
    else
      true
    end
  end
end
