class WritingController < ApplicationController
  before_action :get_case, only: [ :index, :new, :create, :edit, :update, :finalize, :download ]
  before_action :get_writing_type, only: [ :new, :create ]
  before_action :get_writing_draft, only: [ :edit, :update, :finalize, :download ]

  def index
    return if require_permission! :writings_access
    render layout: "layouts/case_view"
  end

  def new
    return if require_permission! :writings_access
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
    return if require_permission! :writings_access
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
    return if require_permission! :writings_access

    if !@writing.is_final
      render layout: "layouts/case_view"
    else
      render "writing/show_final", layout: "layouts/case_view"
    end
  end

  def update
    return if require_permission! :writings_access
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

  def finalize
    return if require_permission! :writings_access
    if @writing_type.has_cosigning_required && !@writing.writing_cosignatures.any?
      flash[:danger] = "Entwurf kann nicht finalisiert werden: erforderliche Gegenzeichnungen wurden nicht verlangt"
      return redirect_to edit_writing_url(@case, @writing)
    end

    @writing.update!(is_final: true, writing_date: Date.today)
    @case.touch

    redirect_to edit_writing_url(@case, @writing)
  end

  def download
    return if require_permission! :writings_access
    return redirect_to edit_writing_url(@case, @writing) unless @writing.is_final

    writing_odt = helpers.create_writing(@writing)

    if params[:format] == "odt"
      send_data writing_odt,
            type: "application/vnd.oasis.opendocument.text",
            disposition: "attachment",
            filename: "report.odt"
    elsif params[:format] == "pdf"
      writing_pdf = helpers.convert_to_pdf(@writing, writing_odt)
      send_data writing_pdf,
            type: "application/pdf",
            # disposition: "attachment",
            filename: "report.pdf"
    end
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
