class Task < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :case
  belongs_to :task_column
  belongs_to :task_resolution_type, optional: true

  has_rich_text :description

  default_scope { where.not(is_deleted: true) }

  scope :that_are_open, -> { where(is_resolved: false) }
  scope :that_are_overdue, -> { where("due < ?", Date.today) }

  def status
    return :deleted if is_deleted
    return :resolved if is_resolved
    return :overdue if due != nil && due < Date.today
    :pending
  end
end
