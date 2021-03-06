class CreateIdentifiers < ActiveRecord::Migration
  def change
    create_table :identifiers do |t|
      t.string :fingerprint
      t.string :ip_address
      t.references :user, index: true

      t.timestamps
    end
  end
end
