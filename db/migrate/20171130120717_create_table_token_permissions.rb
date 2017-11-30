class CreateTableTokenPermissions < ActiveRecord::Migration[5.0]
  def up
    create_table :token_permissions do |t|
       t.references :token
       t.references :permission
    end
  end

  def down
    drop_table :token_permissions
  end
end
