class Case < ApplicationRecord
  belongs_to :case_type
  belongs_to :case_status
  belongs_to :manager, class_name: "User"
end
