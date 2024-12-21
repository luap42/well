class AddPositionToCosignings < ActiveRecord::Migration[7.2]
  def change
    add_column :writing_cosignatures, :position, :integer
  end
end
