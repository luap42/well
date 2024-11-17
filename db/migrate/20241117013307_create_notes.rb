class CreateNotes < ActiveRecord::Migration[7.2]
  def change
    create_table :notes do |t|
      t.timestamps
      t.references :case
      t.references :user
      t.string :title
      t.text :comment
      t.boolean :deleted
    end
  end
end
