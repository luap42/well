class CreateWritingTypes < ActiveRecord::Migration[7.2]
  def change
    create_table :writing_types do |t|
      t.references :user
      t.string :title
      t.string :default_token
      t.boolean :has_recipient
      t.boolean :has_cosigning_required
      t.boolean :is_enabled
      t.timestamps
    end
  end
end
