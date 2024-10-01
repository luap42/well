class AddFurtherFieldsToCase < ActiveRecord::Migration[7.2]
  def change
    add_column :cases, :local_records, :string
    add_reference :cases, :manager, foreign_key: { to_table: :users }
  end
end
