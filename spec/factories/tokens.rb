FactoryGirl.define do
  factory :token, class: Token do
    issued_at { 1.day.ago }
    requested_by { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
    service_name 'some_app'
    fingerprint SecureRandom.uuid
    api_env 'preprod'
    expires { 1.year.from_now }
    contact_email { Faker::Internet.email }
    permissions '.*'
    client_pub_key { File.read("#{Rails.root}/spec/fixtures/files/test_client.pub") }
    state 'inactive'

    trait :inactive do
      state 'inactive'
    end

    trait :active do
      state 'active'
    end

    trait :revoked do
      state 'revoked'
    end
  end
end
