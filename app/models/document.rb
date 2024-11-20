class Document < ApplicationRecord
  belongs_to :case
  belongs_to :folder
  belongs_to :document_type
  belongs_to :user, optional: true
  belongs_to :participant, optional: true
  belongs_to :note, optional: true

  def author_name
    return user.display_name unless user.blank?
    participant.name
  end
end
