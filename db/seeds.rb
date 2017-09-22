# Development seeds
if Rails.env.development?
  %w(dev preprod prod).each do |env_name|
    Environment.find_or_create_by!(name: env_name, provisioning_key: File.read(Rails.root.join("lib/assets/dummy_#{env_name}_provisioner.key")))
  end
end
