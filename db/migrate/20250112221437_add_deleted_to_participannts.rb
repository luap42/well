class AddDeletedToParticipannts < ActiveRecord::Migration[7.2]
  def change
    add_column :participants, :is_deleted, :boolean
    Participant.unscoped.update_all(is_deleted: false)
    
    rename_column :notes, :deleted, :is_deleted
    rename_column :calendar_events, :deleted, :is_deleted
  end
end
