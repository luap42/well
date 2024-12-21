class WritingCosignature < ApplicationRecord
  belongs_to :user
  belongs_to :writing_draft
end
