class Task < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :case
  belongs_to :task_column

  has_rich_text :description

  default_scope { where.not(is_deleted: true) }
end
