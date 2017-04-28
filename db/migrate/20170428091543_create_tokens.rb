class CreateTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :tokens do |t|
      t.datetime :issued_at
      t.string :requested_by
      t.string :client_name
      t.string :fingerprint
      t.string :api_env
      t.datetime :expires
      t.string :contact_email
      t.boolean :revoked, default: false

      t.timestamps
    end
  end
end
