require 'csv'



namespace :import do

  desc 'Task: import tokens from .csv FILE'
  task tokens: :environment do
    file = ENV['FILE']
    raise "FILE is required" unless file.present?
    data = CSV.read(File.expand_path(file), headers: true)
    puts "read #{data.size} rows"
    tokens = 0

    ActiveRecord::Base.transaction do |t|
      data.each_with_index do |row, index|
        puts "importing row #{index} (#{row.to_s})"
        token = Token.from_csv_row(row)
        token.save!
        tokens = tokens + 1
      end
    end
    puts "All done - imported #{tokens} tokens"
  end
end