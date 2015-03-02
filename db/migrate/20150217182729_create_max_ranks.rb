class CreateMaxRanks < ActiveRecord::Migration
  def change
    create_table :max_ranks do |t|
      t.string :value
      t.string :source
      t.boolean :verified, default: false
      t.references :game, index: true
      t.references :rank_type, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
