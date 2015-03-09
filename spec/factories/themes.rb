FactoryGirl.define do
  factory :theme do |theme|
    primary = Faker::Commerce.color
    secondary = Faker::Commerce.color
    theme.name                    "#{primary}-#{secondary}"
    theme.primary_color           primary
    theme.secondary_color         secondary
    theme.panel_text_color        { Faker::Commerce.color }
    theme.nav_link_color          { Faker::Commerce.color }
    theme.nav_link_hover_color    { Faker::Commerce.color }
  end

end
