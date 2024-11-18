class CalendarEvent < ApplicationRecord
  belongs_to :case
  has_rich_text :comment

  default_scope { where.not(deleted: true) }
end
