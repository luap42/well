class AddShortcodeToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :shortcode, :string
  end
end
