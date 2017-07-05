module ImportTokens
  module_function

  def call(csv_filepath)
    raise ArgumentError, "csv_filepath does not exist: '#{csv_filepath}'" unless File.exists?(csv_filepath)

    data = parse_csv_file(csv_filepath)
    import_data_in_transaction(data)
  end


  def parse_csv_file(csv_filepath)
    data = CSV.read(File.expand_path(csv_filepath), headers: true)
    puts "read #{data.size} rows"
    data
  end

  def import_data_in_transaction(data)
    ActiveRecord::Base.transaction do |t|
      new_token_count = run_import(data)
      puts "All done - imported #{new_token_count} tokens"
    end
  end

  def run_import(rows)
    new_tokens = 0

    rows.each_with_index do |row, index|
      puts "importing row #{index} (#{row.to_s})"
      import_row!(row)
      new_tokens = new_tokens + 1
    end
    new_tokens
  end

  def import_row!(row)
    token = ImportedTokenBuilder.build(row)
    token.save!
  end
end
