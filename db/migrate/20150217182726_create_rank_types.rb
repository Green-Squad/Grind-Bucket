class CreateRankTypes < ActiveRecord::Migration
  def change
    create_table :rank_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
