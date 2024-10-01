class AddCaseBeginsHereToCaseStatuses < ActiveRecord::Migration[7.2]
  def change
    add_column :case_statuses, :case_begins_here, :boolean
  end
end
