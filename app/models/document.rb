class Document < ApplicationRecord
  belongs_to :case
  belongs_to :folder
  belongs_to :document_type
  belongs_to :user, optional: true
  belongs_to :participant, optional: true
  belongs_to :note, optional: true

  has_many :document_items

  def author_name
    return user.display_name unless user.blank?
    participant.name
  end

  def true_number
    folder.documents.count - folder.documents.where("created_at > ?", created_at).count
  end

  def document_number
    (folder.documents.count > 667 ? "%04d" : "%03d") % true_number
  end

  def printable_name
    document_number + "_" + name.gsub(/[^a-zA-Z0-9-]+/, "_")
  end

  def primary_item
    document_items.where(is_primary: true).first
  end
end
