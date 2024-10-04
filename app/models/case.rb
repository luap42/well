class Case < ApplicationRecord
  belongs_to :case_type
  belongs_to :case_status
  belongs_to :manager, class_name: "User"

  has_many :participants
end
