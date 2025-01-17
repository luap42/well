class CreateLinkedCases < ActiveRecord::Migration[7.2]
  def change
    create_table :linked_cases do |t|
      t.references :case
      t.references :target_case, foreign_key: { to_table: :cases }
      t.timestamps
    end
  end
end
