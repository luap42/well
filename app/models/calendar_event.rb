class CalendarEvent < ApplicationRecord
  belongs_to :case
  has_rich_text :comment

  default_scope { where.not(is_deleted: true) }

  def time
    which_time&.strftime("%H:%M")
  end
end
