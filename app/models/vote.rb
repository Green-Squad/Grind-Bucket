class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :max_rank

  validates :vote, presence: true, inclusion: { in: [-1, 1] }
  validates :max_rank, presence: true
  validates :user, presence: true

  before_save :verify

  def verify
    if self.id
      vote = Vote.where(user_id: self.user_id, max_rank_id: self.max_rank_id).where('id != ?', self.id).first
    else
      vote = Vote.where(user_id: self.user_id, max_rank_id: self.max_rank_id).first
    end
    
    if vote
      return false    
    end
  end
end
