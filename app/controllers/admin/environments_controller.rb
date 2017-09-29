class Admin::EnvironmentsController < Admin::AdminController
  before_action :set_environment, only: [:show, :edit, :update, :destroy]

  def index
    @environments = Environment.all
  end

  def show
  end

  def new
    @environment = Environment.new
  end

  def create
    @environment = Environment.new(environment_params)

    if @environment.save
      redirect_to [:admin, @environment],
        notice: "#{@environment.name} environment successfully created"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @environment.update(environment_params)
      redirect_to [:admin, @environment],
        notice: "#{@environment.name} environment successfully updated"
    else
      render :edit
    end
  end

  def destroy
    @environment.destroy
    redirect_to admin_environments_url, notice: 'Environment was successfully destroyed.'
  end

  private
    def environment_params
      params.require(:environment).permit(:name, :provisioning_key, :base_url)
    end

    def set_environment
      @environment = Environment.find(params[:id])
    end
end
