class TaskColumn < ApplicationRecord
  belongs_to :case
  has_many :tasks

  default_scope { where(is_enabled: true) }
end
