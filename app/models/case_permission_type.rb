class CasePermissionType < ApplicationRecord
  def grants? (rule)
    # If you are not able to read the case, you shouldn't
    # have access to any other feature either
    return false unless case_read

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

  def attributes
    response = []

    response << "Vorgang sehen" if case_read
    response << "Stammdaten bearbeiten" if case_write
    response << "Beteiligte einsehen" if participants_read
    response << "Beteiligte bearbeiten" if participants_write
    response << "Termine einsehen" if calendar_read
    response << "Termine bearbeiten" if calendar_write
    response << "Aufgaben einsehen" if tasks_read
    response << "Aufgaben bearbeiten" if tasks_write
    response << "Dokumente einsehen" if documents_read
    response << "Dokumente bearbeiten" if documents_write
    response << "Notizen lesen" if notes_read
    response << "Notizen bearbeiten" if notes_write
    response << "Wiedervorlagen verwalten" if representments_access
    response << "Schriftstücke fertigen" if writings_access

    response
  end
end
