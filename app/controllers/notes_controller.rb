class NotesController < ApplicationController
  before_action :get_case, only: [ :index, :edit, :update, :new, :create, :delete, :destroy ]
  before_action :get_note, only: [ :edit, :update, :delete, :destroy ]

  def index
    return if require_permission! :notes_read
    render layout: "layouts/case_view"
  end

  def edit
    return if require_permission! :notes_read
    render layout: "layouts/case_view"
  end

  def update
    return if require_permission! :notes_write
    @note.update!(
      title: params[:note][:title],
      content: params[:note][:content]
    )

    @case.touch

    flash[:success] = "Notiz erfolgreich gespeichert."
    render "notes/edit", layout: "layouts/case_view"
  end

  def new
    return if require_permission! :notes_write
    @note = Note.new(case: @case, is_deleted: false)
    @document = nil

    if params.include? :document
      @document = @case.documents.find(params[:document])
      @note.title = "Notiz zu: #{@document.document_number} - #{@document.name}"
    end

    @note.document = @document

    render layout: "layouts/case_view"
  end

  def create
    return if require_permission! :notes_write
    @note = Note.create!(
      case: @case,
      title: params[:note][:title],
      content: params[:note][:content],
      is_deleted: false,
      user: current_user
    )

    if params[:note].include? :document
      @document = @case.documents.find(params[:note][:document])
      @note.update!(document: @document)
    end

    @case.touch

    flash[:success] = "Notiz erfolgreich gespeichert."
    redirect_to edit_note_path(@case, @note)
  end

  def delete
    return if require_permission! :notes_write
    render layout: "layouts/case_view"
  end

  def destroy
    return if require_permission! :notes_write
    @note.update!(is_deleted: true)
    @case.touch
    flash[:success] = "Notiz erfolgreich gelöscht."
    redirect_to notes_path(@case)
  end

  protected

  def get_note
    @note = Note.where(case: @case).find(params[:note_id])
  end
end
