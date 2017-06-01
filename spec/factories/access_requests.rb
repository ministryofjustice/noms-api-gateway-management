FactoryGirl.define do
  factory :access_request, class: AccessRequest do
    requested_by { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
    contact_email { Faker::Internet.email }
    service_name 'some_app'
    api_env 'preprod'
    reason 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
    client_pub_key_file { File.open("#{Rails.root}/spec/fixtures/test_client.pub") }
    pgp_key_file { File.open("#{Rails.root}/spec/fixtures/test_gpg.asc") }
  end
end
