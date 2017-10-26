class EnvironmentsController < ApplicationController
  def index
    @environments = update_properties(Environment.all)
  end

  private

  def update_properties(environments)
    environments.each(&:update_properties!)
  end
end
