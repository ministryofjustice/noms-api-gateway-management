FactoryBot.define do

  key_group = OpenSSL::PKey::EC::Group.new('prime256v1')
  key = OpenSSL::PKey::EC.generate(key_group)
  pub = OpenSSL::PKey::EC.new(key_group)
  pub.public_key = key.public_key

  factory :token, class: Token do
    issued_at { 1.day.ago }
    requested_by { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
    service_name 'some_app'
    fingerprint SecureRandom.uuid
    expires { 1.year.from_now }
    contact_email { Faker::Internet.email }
    permissions '.*'
    client_pub_key pub.to_pem
    state 'inactive'
    environment do
      env = Environment.find_by(name: 'dev')
      env ? env : create(:environment)
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
