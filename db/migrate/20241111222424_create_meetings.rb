class CreateMeetings < ActiveRecord::Migration[8.0]
  def change
    create_table :meetings do |t|
      t.datetime :date
      t.references :group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
