class CreateRepresentments < ActiveRecord::Migration[7.2]
  def change
    create_table :representments do |t|
      t.timestamps
      t.references :case
      t.date :when
      t.string :reason
      t.references :to_user, foreign_key: { to_table: :users }
      t.references :from_user, foreign_key: { to_table: :users }
      t.boolean :priority
    end
  end
end
