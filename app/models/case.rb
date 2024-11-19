class Case < ApplicationRecord
  belongs_to :case_type
  belongs_to :case_status
  belongs_to :manager, class_name: "User"

  has_many :participants
  has_many :representments
  has_many :notes
  has_many :calendar_events
  has_many :folders

  def default_folder
    folders.where(is_default: true).first
  end

  def ensure_default_folder!
    return if folders.where(is_default: true).any?
    Folder.create!(case: self, name: "Dokumente", is_default: true)
  end
end
