class AddTimeAccessPermission < ActiveRecord::Migration[7.2]
  def change
    add_column :case_permission_types, :time_record_access, :boolean
  end
end
