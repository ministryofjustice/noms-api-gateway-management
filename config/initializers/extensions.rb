require 'delayed_job'

module Delayed
  class Job

    def self.env_ids_in_queue
      queue.map do |job|
        job.job_data['arguments'].first.values.first.split('/').last.to_i
      end
    end

    def self.queue
      all.map { |job| YAML.load(job.handler) }
    end
    
  end
end
