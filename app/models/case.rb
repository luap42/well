class Case < ApplicationRecord
  belongs_to :case_type
  belongs_to :case_status
end
