class UpdateEnvironmentPropertiesJob < ApplicationJob
  queue_as :default

  def perform(env)
    client = NomisApiClient.new(env, ExceptionSafeResponseParser.new)
    env.update_attribute(:health, client.get_health)
    env.update_attribute(:deployed_version, client.get_version)
    env.update_attribute(:deployed_version_timestamp, client.get_version_timestamp)
    env.update_attribute(:properties_last_checked, DateTime.now)
  end
end
