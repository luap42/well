class CreateCasePermissionTypes < ActiveRecord::Migration[7.2]
  def change
    create_table :case_permission_types do |t|
      t.string :name
      t.boolean :case_read
      t.boolean :case_write
      t.boolean :participants_read
      t.boolean :participants_write
      t.boolean :calendar_read
      t.boolean :calendar_write
      t.boolean :documents_read
      t.boolean :documents_write
      t.boolean :notes_read
      t.boolean :notes_write
      t.boolean :tasks_read
      t.boolean :tasks_write
      t.boolean :representments_access
      t.boolean :writings_access
      t.timestamps
    end
  end
end
