class CreateProvisioningKeys < ActiveRecord::Migration[5.0]
  def change
    create_table :provisioning_keys do |t|
      t.string :api_env
      t.text :content

      t.timestamps
    end
  end
end
