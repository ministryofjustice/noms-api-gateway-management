class CreateAccessRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :access_requests do |t|
      t.string :contact_email
      t.string :requested_by
      t.string :service_name
      t.string :api_env
      t.text :reason
      t.text :client_pub_key
      t.text :pgp_key
      t.boolean :processed, default: false

      t.timestamps
    end
  end
end
