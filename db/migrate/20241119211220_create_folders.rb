class CreateFolders < ActiveRecord::Migration[7.2]
  def change
    create_table :folders do |t|
      t.timestamps
      t.references :case
      t.string :name
      t.string :password
      t.boolean :is_protected
      t.boolean :is_default
    end
  end
end
