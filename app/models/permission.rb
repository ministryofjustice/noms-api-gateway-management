class Permission
  def self.all
    {
      all: {
        all:    '.*'
      },
      elite2_api: {
        all:    '^\/elite2api\/.*$',
        health: '^\/elite2api\/info\/health.*$'
      },
      nomis_api: {
        health: '^\/nomisapi\/health$',
        all: '^\/nomisapi\/.*$'
      }   
    }
  end

  def self.flattened
    flattened_perms={}
    all.each do |scope,keys|
      keys.each do |key,val|
        flattened_perms[compound_key(scope, key)]=val
      end
    end
    flattened_perms
  end

  def self.compound_key( scope, key )
    [scope, key].map(&:to_s).join('-')
  end
end
