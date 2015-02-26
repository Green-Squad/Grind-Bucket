class MaxRank < ActiveRecord::Base
  belongs_to :game
  belongs_to :rank_type
  belongs_to :user
  
  validates :source, presence: true
  validates :user, presence: true
  
  def upvotes
    Vote.where(max_rank_id: id, vote: 1).count
  end
  
  def downvotes
    Vote.where(max_rank_id: id, vote: -1).count
  end  
end