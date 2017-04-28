FactoryGirl.define do
  factory :token, class: Token do
    issued_at { 1.day.ago }
    requested_by { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
    client_name 'some_app'
    fingerprint SecureRandom.uuid
    api_env 'preprod'
    expires { 2.years.from_now }
    contact_email { Faker::Internet.email }
    revoked false
  end
end
