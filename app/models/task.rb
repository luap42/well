class Task < ApplicationRecord
  belongs_to :user
  belongs_to :case
  belongs_to :task_column

  default_scope { where.not(is_deleted: true) }
end
