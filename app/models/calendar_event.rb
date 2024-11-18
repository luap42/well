class CalendarEvent < ApplicationRecord
  belongs_to :case
  has_rich_text :comment
end
