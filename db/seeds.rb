# Development seeds
def generate_base_url(env_name)
  if env_name == 'prod'
    "https://noms-api.service.justice.gov.uk/nomisapi/"
  else
    "https://noms-api-#{env_name}.dsd.io/nomisapi/"
  end
end

if Rails.env.development?
  %w(dev preprod prod).each do |env_name|
    Environment.find_or_create_by!(
      name: env_name,
      provisioning_key: File.read(Rails.root.join("lib/assets/dummy_#{env_name}_provisioner.key")),
      base_url: generate_base_url(env_name)
    )
  end
end

