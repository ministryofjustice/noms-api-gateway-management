FactoryGirl.define do
  factory :token, class: Token do
    issued_at { 1.day.ago }
    requested_by { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
    service_name 'some_app'
    fingerprint SecureRandom.uuid
    api_env 'preprod'
    expires { 1.year.from_now }
    contact_email { Faker::Internet.email }
    revoked false
    client_pub_key { File.open("#{Rails.root}/spec/fixtures/test_client.pub").read }
    pgp_key { File.open("#{Rails.root}/spec/fixtures/test_gpg.asc").read }
  end
end
