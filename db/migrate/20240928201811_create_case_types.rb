class CreateCaseTypes < ActiveRecord::Migration[7.2]
  def change
    create_table :case_types do |t|
      t.timestamps
      t.string :prefix
      t.string :title
      t.boolean :enabled
    end
  end
end
