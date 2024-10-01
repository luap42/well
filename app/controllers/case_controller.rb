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
end
