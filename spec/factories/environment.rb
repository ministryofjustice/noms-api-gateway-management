FactoryBot.define do
  factory :environment, class: Environment do
    name 'dev'
    base_url "https://noms-api.TEST.justice.gov.uk/nomisapi/"
    
    provisioning_key do
      File.read("#{Rails.root}/spec/fixtures/files/test_provisioner.key")
    end

    health 'DB Up'
    deployed_version '1.0.0'
    deployed_version_timestamp Time.now
    properties_last_checked Time.now
  end
end
