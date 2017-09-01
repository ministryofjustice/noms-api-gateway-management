class AddKeysToEnvironment < ActiveRecord::Migration[5.0]
  def up
    add_column :environments, :client_pub_key,     :string
    add_column :environments, :client_private_key, :string

    Environment.all.each do |env|
      env.save!
    end
  end

  def down
    remove_column :environments, :client_pub_key,     :string
    remove_column :environments, :client_private_key, :string
  end
end
