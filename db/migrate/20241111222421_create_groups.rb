class CreateGroups < ActiveRecord::Migration[8.0]
  def change
    create_table :groups do |t|
      t.integer :group_type
      t.integer :max_size
      t.string :name

      t.timestamps
    end
  end
end
