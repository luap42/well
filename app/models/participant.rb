class Participant < ApplicationRecord#
  belongs_to :case
  belongs_to :participant_role
end
