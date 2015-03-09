ActiveAdmin.register Theme do
  permit_params :name, :primary_color, :secondary_color, :panel_text_color, :nav_link_color, :nav_link_hover_color
end
