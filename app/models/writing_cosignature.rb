class WritingCosignature < ApplicationRecord
  belongs_to :user
  belongs_to :writing_draft

  default_scope { where(is_obsoleted: false).order(position: :asc) }
end
