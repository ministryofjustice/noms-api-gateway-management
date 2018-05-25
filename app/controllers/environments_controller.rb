class EnvironmentsController < ApplicationController
  def index
    sorted = Environment.order(:id).all
    @environments = update_properties(sorted)
  end

  private

  def update_properties(environments)
    environments.each(&:update_properties!)
  end
end
