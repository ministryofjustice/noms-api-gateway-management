class AddHealthAndVersionToEnvironment < ActiveRecord::Migration[5.0]
  def up
    change_table :environments do |t|
      t.string   :health
      t.string   :deployed_version
      t.datetime :deployed_version_timestamp
      t.datetime :properties_last_checked
      t.integer  :interval, default: 10
    end
  end

  def down
    change_table :environments do |t|
      t.remove :health
      t.remove :deployed_version
      t.remove :deployed_version_timestamp
      t.remove :properties_last_checked
      t.remove :interval
    end
  end
end
