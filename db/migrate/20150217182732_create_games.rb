class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :name
      t.string :image
      t.string :status, default: 'Pending'
      t.string :slug
      t.references :theme, index: true

      t.timestamps
      

    end
    add_index :games, :slug, unique: true
  end
end
