class CreateTaskColumns < ActiveRecord::Migration[7.2]
  def change
    create_table :task_columns do |t|
      t.references :case
      t.string :title
      t.string :default_token
      t.boolean :is_enabled
      t.timestamps
    end
  end
end
