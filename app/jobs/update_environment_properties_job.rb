class UpdateEnvironmentPropertiesJob < ApplicationJob
  queue_as :default

  def perform(env)
    client = NomisApiClient.new(env, ExceptionSafeResponseParser.new)
    env.update_attributes(
      health: client.get_health,
      deployed_version: client.get_version,
      deployed_version_timestamp: client.get_version_timestamp,
      properties_last_checked: DateTime.now
    )
  end
end
