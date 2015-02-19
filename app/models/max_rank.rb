class MaxRank < ActiveRecord::Base
  belongs_to :game
  belongs_to :rank_type
  belongs_to :user
  
  validates :source, presence: true
end
