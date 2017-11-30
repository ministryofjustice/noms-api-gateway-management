class RemovePermissionsFromTokens < ActiveRecord::Migration[5.0]
  def up

    Token.all.each do |token|
      token.attributes['permissions'].split.each do |permission_att_regex|
        permission_object = Permission.find_by(regex: permission_att_regex)
        TokenPermission.create!(
          token: token,
          permission: permission_object
        )
      end
    end

    remove_column :tokens, :permissions, :string
  end

  def down

    add_column :tokens, :permissions, :string

    Token.all.each do |token|
      token.update_column(:permissions, token.permissions.map(&:regex).join("\r\n"))
    end
  end
end
