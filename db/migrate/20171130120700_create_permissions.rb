class CreatePermissions < ActiveRecord::Migration[5.0]
  def up
    create_table :permissions do |t|
      t.string :regex
      t.integer :position
    end

    existing_permissions = Token.all.map { |token| token.permissions.split }.flatten.uniq

    existing_permissions.each do |perm|
      Permission.create!(
        regex: perm,
        position: Permission.any? ? Permission.all.sort_by(&:position).last.position + 100 : 100
      )
    end
  end

  def down
    drop_table :permissions
  end
end
