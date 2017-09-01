class AddJwtToEnvironment < ActiveRecord::Migration[5.0]
  def up
    add_column :environments, :jwt, :text

    Environment.all.each do |env|
      env.save!
    end
  end

  def down
    remove_column :environments, :jwt
  end
end
