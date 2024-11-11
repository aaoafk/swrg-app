class CreateLocations < ActiveRecord::Migration[8.0]
  def change
    create_table :locations do |t|
      t.string :address
      t.references :meeting, null: false, foreign_key: true

      t.timestamps
    end
  end
end
