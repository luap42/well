class WritingDraft < ApplicationRecord
  belongs_to :case
  belongs_to :user
  has_one :participant, required: false
  belongs_to :document_item, required: false
  belongs_to :writing_type

  has_rich_text :content
  default_scope { where.not(is_deleted: true) }
end
