class CreateTaskResolutionTypes < ActiveRecord::Migration[7.2]
  def change
    create_table :task_resolution_types do |t|
      t.string :title
      t.boolean :is_enabled
      t.timestamps
    end
  end
end
