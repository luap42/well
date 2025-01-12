class Note < ApplicationRecord
  belongs_to :case
  belongs_to :user

  has_one :document, required: false

  has_rich_text :content

  default_scope { where.not(is_deleted: true) }
end
