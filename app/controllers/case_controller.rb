class CaseController < ApplicationController
  before_action :require_user_to_sign_in!
  before_action :get_case, only: [ :show, :edit, :update ]

  def index; end

  def search
    @cases = Case.all

    unless params[:case_no].blank?
      @cases = @cases.where(
        "case_no LIKE ? OR case_no LIKE ?",
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

    unless params[:case_status].blank?
      @cases = @cases.where(case_status: CaseStatus.find(params[:case_status]))
    end

    @cases = @cases.order(updated_at: :desc)
  end

  def new
    @case = Case.new
    @case.case_status = CaseStatus.where(case_begins_here: true).first
  end

  def create
    case_type = CaseType.find(params[:case][:case_type])
    case_status = CaseStatus.find(params[:case][:case_status])
    case_no = case_type.new_case_no()

    @case = Case.create!(
      case_type: case_type,
      case_status: case_status,
      case_no: case_no,
      title: params[:case][:title],
      summary: params[:case][:summary]
    )

    flash[:success] = "Vorgang erfolgreich angelegt."

    redirect_to show_case_path(@case.id)
  end

  def show
    render layout: "case_view"
  end

  def edit
    render layout: "case_view"
  end

  def update
    case_type = CaseType.find(params[:case][:case_type])
    case_status = CaseStatus.find(params[:case][:case_status])
    manager = User.find(params[:case][:manager])

    @case.update!(
      case_type: case_type,
      case_status: case_status,
      manager: manager,
      title: params[:case][:title],
      summary: params[:case][:summary],
      local_records: params[:case][:local_records] || nil
    )

    flash[:success] = "Vorgang erfolgreich bearbeitet."

    redirect_to show_case_path(@case.id)
  end

  protected

  def get_case
    @case = Case.find(params[:id])
  end
end
