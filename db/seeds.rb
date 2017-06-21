# Development seeds
if Rails.env.development?
  ApiEnv.all.each do |env|
    ProvisioningKey.find_or_create_by!(api_env: env, content: File.read(Rails.root.join("lib/assets/dummy_#{env}_provisioner.key")))
  end
end
