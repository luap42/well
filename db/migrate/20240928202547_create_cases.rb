class CreateCases < ActiveRecord::Migration[7.2]
  def change
    create_table :cases do |t|
      t.timestamps
      t.references :case_type
      t.references :case_status
      t.string :case_no
      t.string :title
      t.text :summary
    end
  end
end
