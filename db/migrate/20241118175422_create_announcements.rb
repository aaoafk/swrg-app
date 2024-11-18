class CreateAnnouncements < ActiveRecord::Migration[8.0]
  def change
    create_table :announcements do |t|
      t.string :title
      t.text :body
      t.datetime :start_at
      t.datetime :end_at
      t.boolean :active

      t.timestamps
    end
  end
end
