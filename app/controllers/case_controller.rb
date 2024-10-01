class CaseController < ApplicationController
  before_action :require_user_to_sign_in!

  def index; end

  def search
    @cases = Case.all

    unless params[:case_no].blank?
      @cases = @cases.where("case_no LIKE ?", Case.sanitize_sql_like(params[:case_no]) + "%")
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

    redirect_to :root
  end
end
