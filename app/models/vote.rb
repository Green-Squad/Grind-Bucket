class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :max_rank

  validates :vote, presence: true, inclusion: { in: [-1, 1] }
  validates :max_rank, presence: true
  validates :user, presence: true
end
