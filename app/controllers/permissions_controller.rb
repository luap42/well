class PermissionsController < ApplicationController
  before_action :get_case, only: [ :index, :edit, :update ]
  before_action :get_permission, only: [ :edit, :update ]

  def index
    return if require_permission! :case_read
    render layout: "case_view"
  end

  def edit
    return unless current_user.manager_of? @case
    render layout: "case_view"
  end

  def update
    return unless current_user.manager_of? @case

    @case_permission.update!(
      case_permission_type: CasePermissionType.find(params[:case_permission][:permission_type])
    )
    @case.touch

    flash[:success] = "Berechtigung erfolgreich gespeichert."
    redirect_to edit_permission_url(@case, @case_permission)
  end

  protected

  def get_permission
    @case_permission = @case.case_permissions.find(params[:permission_id])
  end
end
