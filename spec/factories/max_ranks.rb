FactoryGirl.define do
  factory :max_rank do |max_rank|
    max_rank.rank_type
    max_rank.game
    max_rank.value          { Faker::Number.number(10) }
    max_rank.source         { Faker::Internet.url }
    max_rank.user
  end

end
