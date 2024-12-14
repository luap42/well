class AddMoreFieldsToTasks < ActiveRecord::Migration[7.2]
  def change
    add_column :tasks, :due, :date
    add_column :tasks, :is_resolved, :boolean
  end
end
