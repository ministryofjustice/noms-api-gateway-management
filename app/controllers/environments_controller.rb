class EnvironmentsController < ApplicationController
  def index
    @environments = Environment.all
  end
end
