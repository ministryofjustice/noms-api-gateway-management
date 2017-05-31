class Admin::AdminController < ApplicationController
  before_action :authenticate!

  protected

  def authenticate!
    # raise 'Unauthenticated'
  end
end
