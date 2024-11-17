class CreateCalendarEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :calendar_events do |t|
      t.timestamps
      t.references :case
      t.string :title
      t.date :when
      t.boolean :deleted
    end
  end
end
