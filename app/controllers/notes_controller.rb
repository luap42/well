class NotesController < ApplicationController
  before_action :get_case, only: [ :index, :edit, :update ]
  before_action :get_note, only: [ :edit, :update ]

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

    flash[:success] = "Notiz erfolgreich gespeichert."
    render "notes/edit", layout: "layouts/case_view"
  end

  protected

  def get_note
    @note = Note.where(case: @case).find(params[:note_id])
  end
end
