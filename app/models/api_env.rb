class ApiEnv
  ENVS = %w( dev preprod prod).freeze

  def self.all
    ENVS
  end
end
