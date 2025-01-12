class Participant < ApplicationRecord
  belongs_to :case
  belongs_to :participant_role

  default_scope { where.not(is_deleted: true) }
end
