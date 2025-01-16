class CreateTimeRecords < ActiveRecord::Migration[7.2]
  def change
    create_table :time_records do |t|
      t.references :case
      t.references :user
      t.string :comment
      t.datetime :begins_at
      t.datetime :ends_at
      t.boolean :running
      t.timestamps
    end
  end
end
