class WritingType < ApplicationRecord
  belongs_to :user
  has_one_attached :template

  default_scope { where(is_enabled: true) }
end
