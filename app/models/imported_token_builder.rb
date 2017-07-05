# Builds a valid Token object
# from a given CSV row.
class ImportedTokenBuilder

  def self.build(row={})
    Token.new(
      mapped_csv_values(row).merge(required_values_not_in_csv)
    )
  end

  protected

  def self.mapped_csv_values(row)
    {
      api_env: row['NOMS API env'],
      expires: row['Expiry date'] || Time.now + 1.year, 
      fingerprint: row['Token fingerprint'],
      requested_by: row['Requested by'] || '(unknown)',
      service_name: row['Client name']
    }
  end

  def self.required_values_not_in_csv
    {
      contact_email: 'unknown',
      client_pub_key: nil,
      created_from: 'import',
      permissions: nil,
      state: 'active',
      trackback_token: nil
    }
  end
end