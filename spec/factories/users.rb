FactoryGirl.define do
  
  factory :user do |user|
    
    password = Faker::Internet.password
    
    user.email                  { Faker::Internet.email }
    user.password               password
    user.password_confirmation  password
  end

end
