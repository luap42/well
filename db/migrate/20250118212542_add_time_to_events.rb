class AddTimeToEvents < ActiveRecord::Migration[7.2]
  def change
    add_column :calendar_events, :which_time, :time
  end
end
