class CreateThemes < ActiveRecord::Migration
  def change
    create_table :themes do |t|
      t.string :name
      t.string :primary_color
      t.string :secondary_color
      t.string :panel_text_color
      t.string :nav_link_color
      t.string :nav_link_hover_color

      t.timestamps null: false
    end
  end
end
