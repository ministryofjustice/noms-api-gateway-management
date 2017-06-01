class CreateTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :tokens do |t|
      t.datetime :issued_at
      t.string :requested_by
      t.string :service_name
      t.string :fingerprint
      t.string :api_env
      t.datetime :expires
      t.string :contact_email
      t.boolean :revoked, default: false
      t.text :client_pub_key
      t.text :pgp_key

      t.timestamps
    end
  end
end
