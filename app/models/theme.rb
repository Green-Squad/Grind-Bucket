class Theme < ActiveRecord::Base
  def generate
    directory = Rails.root.join('app', 'assets', 'stylesheets', 'required', 'themes')
    File.open(directory.join("#{name}.scss"), 'w') do |f|
      f.write(
"@import 'variables';

$primary-color: #{primary_color};
$secondary-color: #{secondary_color};
$panel-text-color: #{panel_text_color};
$nav-link-color: #{nav_link_color};
$nav-link-hover-color: #{nav_link_hover_color};

.#{name} {
  @import 'theme-base'
}")

    end
  end

  def self.generate_all
    Theme.all.each do |theme|
      theme.generate
    end
  end

  def to_s
    name
  end

end
