class AddResolutionTypeToTasks < ActiveRecord::Migration[7.2]
  def change
    add_reference :tasks, :task_resolution_type
  end
end
