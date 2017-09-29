class AddBaseUrlToEnvironment < ActiveRecord::Migration[5.0]
  def up
    add_column :environments, :base_url, :string

    Environment.all.each do |env|
      env.base_url = if env.name == 'prod'
        "https://noms-api.service.justice.gov.uk/nomisapi/"
      else
        "https://noms-api-#{env.name}.dsd.io/nomisapi/"
      end

      env.save!
    end
  end

  def down
    remove_column :environments, :base_url
  end
end
