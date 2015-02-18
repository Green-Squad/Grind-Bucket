FactoryGirl.define do
  
  factory :admin_user do |admin_user|
    
    password = Faker::Internet.password
    
    admin_user.email                  { Faker::Internet.email }
    admin_user.password               password
    admin_user.password_confirmation  password
  end

end
