class AddDismissalToRepresentments < ActiveRecord::Migration[7.2]
  def change
    add_column :representments, :dismissed, :boolean
    Representment.unscoped.update_all(dismissed: false)
  end
end
