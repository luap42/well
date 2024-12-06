class CreateDocumentItems < ActiveRecord::Migration[7.2]
  def change
    create_table :document_items do |t|
      t.references :case
      t.references :folder
      t.references :document

      t.string :file_name
      t.boolean :is_primary
      t.boolean :is_attachment
      t.boolean :is_transactional
      t.timestamps
    end
  end
end
