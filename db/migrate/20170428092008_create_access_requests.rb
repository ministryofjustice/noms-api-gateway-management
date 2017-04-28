class CreateAccessRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :access_requests do |t|
      t.string :email
      t.string :name
      t.text :reason

      t.timestamps
    end
  end
end
