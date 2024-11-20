class CreateDocumentTypes < ActiveRecord::Migration[7.2]
  def change
    create_table :document_types do |t|
      t.timestamps
      t.string :title
      t.text :description
      t.boolean :is_enabled
    end
  end
end
