module Auth
  class NotAuthorized < RuntimeError; end
  class NotLoggedIn < RuntimeError; end
end