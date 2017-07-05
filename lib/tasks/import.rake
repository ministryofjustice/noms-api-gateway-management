require 'csv'

namespace :import do

  desc 'Task: import tokens from .csv FILE'
  task tokens: :environment do
    file = ENV['FILE']
    raise "FILE is required" unless file.present?
    ImportTokens.call(file)
  end
end