FactoryGirl.define do
  factory :rank_type do |rank_type|
    rank_type.name       { Faker::Name.name }
  end

end
