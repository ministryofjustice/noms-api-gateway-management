# a convenience wrapper around the information returned by moj-signon
# as defined in:
# https://github.com/ministryofjustice/moj-signon#how-to-integrate
class User
  attr_accessor :id, :email, :first_name, :last_name
  attr_accessor :permissions, :organisation, :roles
  attr_accessor :links

  def self.from_moj_signon_data(data={})
    u = new
    attrs = :id, :email, :first_name, :last_name, :permissions, :links
    attrs.each do |name|
      u.send("#{name.to_s}=", data[name.to_s])
    end
    u
  end

  def roles
    permissions ? permissions[0]['roles'] : nil
  end

  def admin?
    Array(roles).include?('admin')
  end
end
