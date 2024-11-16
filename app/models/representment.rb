class Representment < ApplicationRecord
  belongs_to :case
  belongs_to :to_user, class_name: "User"
  belongs_to :from_user, class_name: "User"

  scope :current, -> { where(when: ..Date.today).order(priority: :desc, when: :asc) }
end
