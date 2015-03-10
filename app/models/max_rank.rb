class MaxRank < ActiveRecord::Base
  belongs_to :game
  belongs_to :rank_type
  belongs_to :user
  has_many :vote
  
  validates :source, presence: true
  validates :user, presence: true
  
  def upvotes
    Vote.where(max_rank_id: id, vote: 1).count
  end
  
  def downvotes
    Vote.where(max_rank_id: id, vote: -1).count
  end
  
  def verify
    self.verified = true
    save
  end
  
  def unverify
    self.verified = false
    save
  end    
  
  def self.sort(array)
    sorted_array = array.sort do |a, b|
        if b[:upvotes] - b[:downvotes] < a[:upvotes] - a[:downvotes]
          -1
        elsif b[:upvotes] - b[:downvotes] > a[:upvotes] - a[:downvotes]
          1
        else
          b[:upvotes] + b[:downvotes] <=> a[:upvotes] + a[:downvotes]
        end
      end
  end
end