class CaseStatus < ApplicationRecord
  belongs_to :next_step, class_name: "CaseStatus", optional: true
end
