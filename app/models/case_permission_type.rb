class CasePermissionType < ApplicationRecord
  def grants? (rule)
    case (rule)
    when :case_read
      case_read
    when :case_write
      case_write
    when :participants_read
      participants_read
    when :participants_write
      participants_write
    when :calendar_read
      calendar_read
    when :calendar_write
      calendar_write
    when :tasks_read
      tasks_read
    when :tasks_write
      tasks_write
    when :documents_read
      documents_read
    when :documents_write
      documents_write
    when :notes_read
      notes_read
    when :notes_write
      notes_write
    when :representments_access
      representments_access
    when :writings_access
      writings_access
    else
      false
    end
  end
end
