class CaseStatus < ApplicationRecord
  default_scope { where(enabled: true) }
  belongs_to :next_step, class_name: "CaseStatus", optional: true
end
