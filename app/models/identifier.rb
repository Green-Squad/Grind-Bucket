class Identifier < ActiveRecord::Base
  belongs_to :user
  validates :ip_address,  presence: true
  validates :fingerprint, presence: true
  validates :user_id,     presence: true
  
end
