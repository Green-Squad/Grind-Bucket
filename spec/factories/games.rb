FactoryGirl.define do
  factory :game do |game|
    game.name       { Faker::Name.name }
    game.status     'Pending'
  end

end
