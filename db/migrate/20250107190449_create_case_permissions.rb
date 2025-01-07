class CreateCasePermissions < ActiveRecord::Migration[7.2]
  def change
    create_table :case_permissions do |t|
      t.references :case
      t.references :user
      t.references :case_permission_type
      t.timestamps
    end
  end
end
