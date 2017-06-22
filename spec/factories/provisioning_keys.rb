FactoryGirl.define do
  factory :provisioning_key, class: ProvisioningKey do
    api_env 'preprod'
    content { File.read("#{Rails.root}/spec/fixtures/files/test_provisioner.key") }
  end
end
