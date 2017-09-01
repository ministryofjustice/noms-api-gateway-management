class EnvironmentsController < Admin::AdminController
  def index
    @environments = Environment.all
  end
end
