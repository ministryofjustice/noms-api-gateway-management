class AddTokenCreatedFrom < ActiveRecord::Migration[5.0]
  def change
    add_column Token, :created_from, :string, default: 'web'
  end
end
