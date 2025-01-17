class LinkedCase < ApplicationRecord
  belongs_to :case
  belongs_to :target_case, class_name: "Case"
end
