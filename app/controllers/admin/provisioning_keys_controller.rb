class Admin::ProvisioningKeysController < Admin::AdminController
  before_action :set_provisioning_key, only: [:show, :destroy]

  def index
    @provisioning_keys = ProvisioningKey.all
  end

  def show
  end

  def new
    @provisioning_key = ProvisioningKey.new
  end

  def create
    @provisioning_key = ProvisioningKey.new(provisioning_key_params)
    if @provisioning_key.save
      redirect_to [:admin, @provisioning_key],
        notice: "Provision key successfully created for environment #{@provisioning_key.api_env}"
    else
      render :new
    end
  end

  def destroy
    @provisioning_key.destroy
    redirect_to admin_provisioning_keys_url, notice: 'Provisioning key was successfully destroyed.'
  end

  private
    def provisioning_key_params
      params.require(:provisioning_key).permit(:api_env, :content)
    end

    def set_provisioning_key
      @provisioning_key = ProvisioningKey.find(params[:id])
    end
end
