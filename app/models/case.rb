class Case < ApplicationRecord
  belongs_to :case_type
  belongs_to :case_status
  belongs_to :manager, class_name: "User"

  has_many :participants
  has_many :representments
  has_many :notes
  has_many :calendar_events
  has_many :folders
  has_many :documents
  has_many :task_columns
  has_many :writing_drafts

  scope :that_are_open, -> { where(case_status: CaseStatus.where.not(case_ends_here: true)) }

  def default_folder
    folders.where(is_default: true).first
  end

  def ensure_default_folder!
    return if folders.where(is_default: true).any?
    Folder.create!(case: self, name: "Dokumente", is_default: true)
  end

  def ensure_default_task_columns!
    TaskColumn.create!(
      case: self,
      title: "10 - Ausstehend",
      default_token: "open",
      is_enabled: true
    ) unless task_columns.where(default_token: "open").any?

    TaskColumn.create!(
      case: self,
      title: "20 - In Bearbeitung",
      default_token: "pending",
      is_enabled: true
    ) unless task_columns.where(default_token: "pending").any?

    TaskColumn.create!(
      case: self,
      title: "30 - Erledigt",
      default_token: "done",
      is_enabled: true
    ) unless task_columns.where(default_token: "done").any?
  end
end
