class RenameProvisioningKeysToEnvironments < ActiveRecord::Migration[5.0]
  def up
    rename_table  :provisioning_keys, :environments
    rename_column :environments,      :api_env, :name
    rename_column :environments,      :content, :provisioning_key

    add_reference :access_requests, :environment
    add_reference :tokens,          :environment

    Token.all.each do |token|
      env = Environment.find_by(name: token.api_env)
      token.environment_id = env.id
      token.save!
    end

    AccessRequest.all.each do |access_request|
      env = Environment.find_by(name: access_request.api_env)
      access_request.environment_id = env.id
      access_request.save!
    end

    remove_column :tokens,          :api_env
    remove_column :access_requests, :api_env
  end

  def down
    add_column :tokens,          :api_env, :string
    add_column :access_requests, :api_env, :string

    Token.all.each do |token|
      env_name = token.environment.name
      token.api_env = env_name
      token.save!
    end

    AccessRequest.all.each do |access_request|
      env_name = access_request.environment.name
      access_request.api_env = env_name
      access_request.save!
    end

    rename_table  :environments,      :provisioning_keys
    rename_column :provisioning_keys, :name,             :api_env
    rename_column :provisioning_keys, :provisioning_key, :content

    remove_column :tokens,          :environment_id
    remove_column :access_requests, :environment_id
  end
end
