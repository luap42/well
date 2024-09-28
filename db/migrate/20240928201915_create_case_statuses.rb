class CreateCaseStatuses < ActiveRecord::Migration[7.2]
  def change
    create_table :case_statuses do |t|
      t.timestamps
      t.string :title
      t.string :color
      t.references :next_step, foreign_key: { to_table: :case_statuses }
      t.boolean :case_ends_here
      t.boolean :enabled
    end
  end
end
