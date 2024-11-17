class Note < ApplicationRecord
  belongs_to :case
  belongs_to :user

  has_rich_text :content
end
