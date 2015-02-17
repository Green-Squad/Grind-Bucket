class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :user, index: true
      t.references :max_rank, index: true
      t.integer :vote

      t.timestamps
    end
  end
end
