class NotesController < ApplicationController
  before_action :get_case, only: [ :index, :edit, :update, :new, :create, :delete, :destroy ]
  before_action :get_note, only: [ :edit, :update, :delete, :destroy ]

  def index
    render layout: "layouts/case_view"
  end

  def edit
    render layout: "layouts/case_view"
  end

  def update
    @note.update!(
      title: params[:note][:title],
      content: params[:note][:content]
    )

    @case.touch

    flash[:success] = "Notiz erfolgreich gespeichert."
    render "notes/edit", layout: "layouts/case_view"
  end

  def new
    @note = Note.new(case: @case, deleted: false)
    @document = nil

    if params.include? :document
      @document = @case.documents.find(params[:document])
      @note.title = "Notiz zu: #{@document.document_number} - #{@document.name}"
    end

    @note.document = @document

    render layout: "layouts/case_view"
  end

  def create
    @note = Note.create!(
      case: @case,
      title: params[:note][:title],
      content: params[:note][:content],
      deleted: false,
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
    render layout: "layouts/case_view"
  end

  def destroy
    @note.update!(deleted: true)
    @case.touch
    flash[:success] = "Notiz erfolgreich gelöscht."
    redirect_to notes_path(@case)
  end

  protected

  def get_note
    @note = Note.where(case: @case).find(params[:note_id])
  end
end
