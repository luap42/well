class CaseController < ApplicationController
  before_action :get_case, only: [ :show, :edit, :update, :canonize, :pin, :unpin ]

  def index; end

  def search
    @cases = Case.all

    if params[:case_status].blank? || params[:case_status] == "open"
      @cases = Case.that_are_open
    elsif params[:case_status] == "all"
      @cases = Case.all
    else
      @cases = Case.all.where(case_status: CaseStatus.find(params[:case_status]))
    end

    unless params[:case_no].blank?
      @cases = @cases.where(
        "case_no LIKE ? OR case_no LIKE ? OR pre_canonical_no LIKE ? OR pre_canonical_no LIKE ?",
        # for case_no
        Case.sanitize_sql_like(params[:case_no]) + "%",
        "%" + Case.sanitize_sql_like(params[:case_no]),
        # for pre_canonical_no
        Case.sanitize_sql_like(params[:case_no]) + "%",
        "%" + Case.sanitize_sql_like(params[:case_no])
      )
    end

    unless params[:title].blank?
      @cases = @cases.where("title LIKE ?", "%" + Case.sanitize_sql_like(params[:title]) + "%")
    end

    unless params[:case_type].blank?
      @cases = @cases.where(case_type: CaseType.find(params[:case_type]))
    end

    @cases = @cases.order(updated_at: :desc)
    @cases = @cases.filter { |c| c.user_has_permission?(current_user, :case_read) }
  end

  def new
    @case = Case.new
    @case.case_status = CaseStatus.where(case_begins_here: true).first
  end

  def create
    case_type = CaseType.find(params[:case][:case_type])
    case_status = CaseStatus.find(params[:case][:case_status])

    if params[:case][:back_for_year].blank?
      case_no = case_type.new_case_no()
    else
      case_no = case_type.new_case_no(year: Date.new(params[:case][:back_for_year].to_i))
    end

    @case = Case.create!(
      case_type: case_type,
      case_status: case_status,
      case_no: case_no,
      title: params[:case][:title],
      summary: params[:case][:summary],
      manager: current_user,
      is_canonical: false
    )

    flash[:success] = "Vorgang erfolgreich angelegt."

    redirect_to show_case_path(@case.id)
  end

  def show
    render layout: "case_view"
  end

  def edit
    return if require_permission! :case_write
    render layout: "case_view"
  end

  def update
    return if require_permission! :case_write

    case_type = CaseType.find(params[:case][:case_type])
    case_status = CaseStatus.find(params[:case][:case_status])

    @case.update!(
      case_type: case_type,
      case_status: case_status,
      title: params[:case][:title],
      summary: params[:case][:summary],
      local_records: params[:case][:local_records] || nil
    )

    @case.input_to_linked_cases(params[:case][:linked_cases_input])

    if current_user.manager_of? @case
      manager = User.find(params[:case][:manager])
      @case.update!(manager: manager)
    end

    flash[:success] = "Vorgang erfolgreich bearbeitet."

    redirect_to show_case_path(@case)
  end

  def canonize
    return if require_case_manager!

    unless @case.is_canonical
      @case.canonize!
      flash[:success] = "Vorgang wurde erfolgreich als Grundsatzvorgang markiert."
    end

    redirect_to show_case_path(@case)
  end

  def pin
    unless current_user.pinned_cases.where(case: @case).any?
      PinnedCase.create!(user: current_user, case: @case)
      flash[:success] = "Vorgang wurde erfolgreich auf der Startseite angeheftet."
    end

    redirect_to show_case_path(@case)
  end

  def unpin
    if current_user.pinned_cases.where(case: @case).any?
      current_user.pinned_cases.where(case: @case).first.delete
      flash[:success] = "Vorgang wurde erfolgreich von der Startseite abgelöst."
    end

    redirect_to show_case_path(@case)
  end
end
