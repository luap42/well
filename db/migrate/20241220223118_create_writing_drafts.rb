class CreateWritingDrafts < ActiveRecord::Migration[7.2]
  def change
    create_table :writing_drafts do |t|
      t.references :case
      t.references :user
      t.references :participant
      t.references :document_item
      t.references :writing_type

      t.string :title
      t.date :writing_date

      t.boolean :is_final
      t.boolean :is_confirmed
      t.boolean :is_deleted
      t.timestamps
    end
  end
end
