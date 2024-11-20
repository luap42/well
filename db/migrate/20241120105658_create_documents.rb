class CreateDocuments < ActiveRecord::Migration[7.2]
  def change
    create_table :documents do |t|
      t.timestamps
      t.references :case
      t.references :folder
      t.references :document_type
      t.references :user
      t.references :participant
      t.references :note
      t.string :name
      t.boolean :is_deleted
    end
  end
end
