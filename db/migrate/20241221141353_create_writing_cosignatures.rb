class CreateWritingCosignatures < ActiveRecord::Migration[7.2]
  def change
    create_table :writing_cosignatures do |t|
      t.references :user
      t.references :writing_draft
      t.string :request
      t.text :response

      t.boolean :is_pending
      t.boolean :is_obsoleted
      t.boolean :is_given
      t.date :given_at

      t.timestamps
    end
  end
end
