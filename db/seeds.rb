# Development seeds
def generate_base_url(env_name)
  if env_name == 'prod'
    "https://noms-api.service.justice.gov.uk/nomisapi/"
  else
    "https://noms-api-#{env_name}.dsd.io/nomisapi/"
  end
end

if Rails.env.development?
  [
    { regex: "^\\/nomisapi\\/version$", position: 100 },
    { regex: "^\\/nomisapi\\/health$", position: 200 }
  ].each do |permission_data|
    Permission.find_or_create_by!(
      regex: permission_data[:regex],
      position: permission_data[:position]
    )
  end

  %w(dev preprod prod).each do |env_name|
    Environment.find_or_create_by!(
      name: env_name,
      provisioning_key: File.read(Rails.root.join("lib/assets/dummy_#{env_name}_provisioner.key")),
      base_url: generate_base_url(env_name)
    )
  end
end
