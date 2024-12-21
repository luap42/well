class WritingController < ApplicationController
  before_action :get_case, only: [ :new, :create, :edit, :update ]
  before_action :get_writing_type, only: [ :new, :create ]
  before_action :get_writing_draft, only: [ :edit, :update ]

  def new
    @writing = WritingDraft.new(
      case: @case,
      user: current_user,
      writing_type: @writing_type,
    )

    if @writing_type.has_recipient
      @writing.title = @case.title
    end

    render layout: "layouts/case_view"
  end

  def create
    @writing = WritingDraft.create!(
      case: @case,
      user: current_user,
      writing_type: @writing_type,
      document_item: nil,
      participant: @writing_type.has_recipient ? @case.participants.find(params[:writing_draft][:participant]) : nil,
      title: params[:writing_draft][:title],
      content: params[:writing_draft][:content],
      is_final: false,
      is_confirmed: false,
      is_deleted: false,
      writing_date: nil
    )
    @writing.input_to_cosignatures(params[:writing_draft][:cosignatures])
    @case.touch

    flash[:success] = "Entwurf erfolgreich erstellt"
    redirect_to edit_writing_url(@case, @writing)
  end

  def edit
    render layout: "layouts/case_view"
  end

  def update
    @writing.update!(
      participant: @writing_type.has_recipient ? @case.participants.find(params[:writing_draft][:participant]) : nil,
      title: params[:writing_draft][:title],
      content: params[:writing_draft][:content],
    )
    @writing.input_to_cosignatures(params[:writing_draft][:cosignatures])
    @case.touch

    flash[:success] = "Entwurf erfolgreich gespeichert"
    render "writing/edit", layout: "layouts/case_view"
  end

  protected

  def get_writing_type
    @writing_type = current_user.writing_types.find(params[:type_id])
  end

  def get_writing_draft
    @writing = WritingDraft.where(case: @case).find(params[:draft_id])
    @writing_type = @writing.writing_type
  end
end
