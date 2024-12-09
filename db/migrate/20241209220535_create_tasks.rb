class CreateTasks < ActiveRecord::Migration[7.2]
  def change
    create_table :tasks do |t|
      t.references :case
      t.references :task_column
      t.references :user

      t.string :title
      t.boolean :is_deleted
      t.timestamps
    end
  end
end
