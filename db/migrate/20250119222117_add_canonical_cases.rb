class AddCanonicalCases < ActiveRecord::Migration[7.2]
  def change
    add_column :cases, :is_canonical, :boolean
    add_column :cases, :pre_canonical_no, :string
  end
end
