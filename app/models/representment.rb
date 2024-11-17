class Representment < ApplicationRecord
  belongs_to :case
  belongs_to :to_user, class_name: "User"
  belongs_to :from_user, class_name: "User"

  default_scope { where.not(dismissed: true) }
  scope :current, -> { where(when: ..Date.today).order(priority: :desc, when: :asc) }
  scope :future, -> { where.not(when: ..Date.today).order(priority: :desc, when: :asc) }
end
