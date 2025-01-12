class TasksController < ApplicationController
  before_action :get_case, only: [ :index, :edit, :update, :new, :create, :edit_task_column,
                                   :update_task_column, :new_task_column, :create_task_column,
                                  :delete, :destroy ]
  before_action :get_task, only: [ :edit, :update, :delete, :destroy ]
  before_action :get_task_column, only: [ :edit_task_column, :update_task_column ]

  def index
    return if require_permission! :tasks_read
    render layout: "layouts/case_view"
  end

  def edit
    return if require_permission! :tasks_read
    render layout: "layouts/case_view"
  end

  def update
    return if require_permission! :tasks_write
    @task.update!(
      title: params[:task][:title],
      description: params[:task][:description],
      user: params[:task][:user].blank? ? nil : User.find(params[:task][:user]),
      task_column: @case.task_columns.find(params[:task][:task_column]),
      due: params[:task][:due].blank? ? nil : params[:task][:due].to_date,
      is_resolved: params[:task][:is_resolved] == "1",
      task_resolution_type: (params[:task][:task_resolution_type].blank? ? nil :
          TaskResolutionType.find(params[:task][:task_resolution_type]))
    )
    @case.touch

    flash[:success] = "Aufgabe erfolgreich gespeichert."
    render "tasks/edit", layout: "layouts/case_view"
  end

  def new
    return if require_permission! :tasks_write
    @task = Task.new(
      case: @case,
      task_column: @case.task_columns.where(default_token: "open").first,
      is_resolved: false,
      is_deleted: false
    )

    render layout: "layouts/case_view"
  end

  def create
    return if require_permission! :tasks_write
    @task = Task.create!(
      case: @case,
      is_deleted: false,
      title: params[:task][:title],
      description: params[:task][:description],
      user: params[:task][:user].blank? ? nil : User.find(params[:task][:user]),
      task_column: @case.task_columns.find(params[:task][:task_column]),
      due: params[:task][:due].blank? ? nil : params[:task][:due].to_date,
      is_resolved: params[:task][:is_resolved] == "1",
      task_resolution_type: (params[:task][:task_resolution_type].blank? ? nil :
          TaskResolutionType.find(params[:task][:task_resolution_type]))
    )

    flash[:success] = "Aufgabe erfolgreich erstellt."
    redirect_to edit_task_path(@case, @task)
  end

  def edit_task_column
    return if require_permission! :tasks_write
    render layout: "layouts/case_view"
  end

  def update_task_column
    return if require_permission! :tasks_write
    @task_column.update!(
      title: params[:task_column][:title],
      is_enabled: params[:task_column][:is_enabled] == "1"
    )
    @case.touch

    flash[:success] = "Spalte erfolgreich gespeichert."
    render "tasks/edit_task_column", layout: "layouts/case_view"
  end

  def new_task_column
    return if require_permission! :tasks_write
    @task_column = TaskColumn.new(
      case: @case,
      is_enabled: true,
      default_token: ""
    )

    render layout: "layouts/case_view"
  end

  def create_task_column
    return if require_permission! :tasks_write
    @task_column = TaskColumn.create!(
      case: @case,
      title: params[:task_column][:title],
      is_enabled: params[:task_column][:is_enabled] == "1",
      default_token: ""
    )
    @case.touch

    flash[:success] = "Spalte erfolgreich erstellt."
    redirect_to edit_task_column_path(@case, @task_column)
  end

  def delete
    return if require_permission! :tasks_write
    render layout: "layouts/case_view"
  end

  def destroy
    return if require_permission! :tasks_write
    @task.update!(is_deleted: true)
    @case.touch
    flash[:success] = "Aufgabe erfolgreich gelöscht."
    redirect_to tasks_path(@case)
  end

  protected

  def get_task
    @task = Task.where(case: @case).find(params[:task_id])
  end

  def get_task_column
    @task_column = TaskColumn.where(case: @case).find(params[:task_column_id])
  end
end
