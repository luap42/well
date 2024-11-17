class Note < ApplicationRecord
  belongs_to :case
  belongs_to :user

  has_rich_text :content

  default_scope { where.not(deleted: true) }
end
