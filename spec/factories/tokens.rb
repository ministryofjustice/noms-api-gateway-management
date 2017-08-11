FactoryGirl.define do

  key_files = %w(test_client.pub test_client_2.pub)

  factory :token, class: Token do
    issued_at { 1.day.ago }
    requested_by { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
    service_name 'some_app'
    fingerprint SecureRandom.uuid
    expires { 1.year.from_now }
    contact_email { Faker::Internet.email }
    permissions '.*'
    client_pub_key { File.read("#{Rails.root}/spec/fixtures/files/#{key_files[Token.count]}") }
    state 'inactive'
    environment do
      Environment.find_or_create_by!(
        name: 'preprod',
        provisioning_key: File.read("#{Rails.root}/spec/fixtures/files/test_provisioner.key")
      )
    end

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
