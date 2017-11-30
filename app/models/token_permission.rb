class TokenPermission < ApplicationRecord
  belongs_to :token
  belongs_to :permission
end
