class PermissionsController < ApplicationController
  before_action :get_case, only: [ :index, :edit, :update, :new, :create, :delete, :destroy ]
  before_action :get_permission, only: [ :edit, :update, :delete, :destroy ]

  def index
    return if require_case_manager!
    render layout: "case_view"
  end

  def edit
    return if require_case_manager!
    render layout: "case_view"
  end

  def update
    return if require_case_manager!

    @case_permission.update!(
      case_permission_type: CasePermissionType.find(params[:case_permission][:permission_type])
    )
    @case.touch

    flash[:success] = "Berechtigung erfolgreich gespeichert."
    redirect_to edit_permission_url(@case, @case_permission)
  end

  def new
    return if require_case_manager!
    @case_permission = CasePermission.new(case: @case)
    render layout: "case_view"
  end

  def create
    return if require_case_manager!

    @case_permission = CasePermission.create!(
      case: @case,
      user: User.find(params[:case_permission][:user]),
      case_permission_type: CasePermissionType.find(params[:case_permission][:permission_type])
    )
    @case.touch

    flash[:success] = "Berechtigung erfolgreich hinzugefügt."
    redirect_to edit_permission_url(@case, @case_permission)
  end

  def delete
    return if require_case_manager!
    render layout: "case_view"
  end

  def destroy
    return if require_case_manager!

    @case_permission.destroy!
    @case.touch

    flash[:success] = "Berechtigung erfolgreich gelöscht."
    redirect_to permissions_url(@case)
  end

  protected

  def get_permission
    @case_permission = @case.case_permissions.find(params[:permission_id])
  end
end
