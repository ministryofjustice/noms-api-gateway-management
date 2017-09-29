FactoryGirl.define do
  factory :environment, class: Environment do
    name 'preprod'
    base_url "https://noms-api.TEST.justice.gov.uk/nomisapi/"
    provisioning_key do
      File.read("#{Rails.root}/spec/fixtures/files/test_provisioner.key")
    end
  end
end
