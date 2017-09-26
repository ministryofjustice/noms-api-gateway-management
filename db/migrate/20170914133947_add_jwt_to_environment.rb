class AddJwtToEnvironment < ActiveRecord::Migration[5.0]
  def up
    add_column :environments, :jwt, :text

    Environment.all.each do |env|
      env.send(:generate_client_keys)
      env.send(:generate_jwt)
      env.save!
    end
  end

  def down
    remove_column :environments, :jwt
  end
end
