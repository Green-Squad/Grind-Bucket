class MaxRank < ActiveRecord::Base
  belongs_to :game
  belongs_to :rank_type
  belongs_to :user
  has_many :vote

  after_commit :clear_recent_activity
  after_commit :clear_unverified_max_ranks
  after_commit :clear_verified_max_ranks

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

  private
  
  def clear_recent_activity
    Rails.cache.delete('home/recent-activity')
  end

  def clear_unverified_max_ranks
    Rails.cache.delete("max_ranks/unverified/#{self.game.id}-#{self.game.name}")
  end

  def clear_verified_max_ranks
    Rails.cache.delete("max_ranks/verified/#{self.game.id}-#{self.game.name}")
  end
  
end