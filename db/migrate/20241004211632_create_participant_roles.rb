class CreateParticipantRoles < ActiveRecord::Migration[7.2]
  def change
    create_table :participant_roles do |t|
      t.timestamps
      t.string :title
      t.boolean :enabled
    end
  end
end
