class WritingCosignature < ApplicationRecord
  belongs_to :user
  belongs_to :writing_draft

  default_scope { order(position: :asc) }
end
