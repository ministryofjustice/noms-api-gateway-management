class EnvironmentsController < ApplicationController
  def index
    @environments = populate_properties(Environment.all)
  end

  private

  def populate_properties(environments)
    environments.each(&:populate_properties!)
  end
end
