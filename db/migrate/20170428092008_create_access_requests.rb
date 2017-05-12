class CreateAccessRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :access_requests do |t|
      t.string :email
      t.string :name
      t.string :app_name
      t.string :api_env
      t.text :reason
      t.text :client_pub_key
      t.text :pgp_key

      t.timestamps
    end
  end
end
