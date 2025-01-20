class CreatePinnedCases < ActiveRecord::Migration[7.2]
  def change
    create_table :pinned_cases do |t|
      t.references :case
      t.references :user
      t.timestamps
    end
  end
end
