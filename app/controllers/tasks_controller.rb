class TasksController < ApplicationController
  before_action :get_case, only: [ :index, :edit, :update, :new, :create ]
  before_action :get_task, only: [ :edit, :update ]

  def index
    render layout: "layouts/case_view"
  end

  def edit
    render layout: "layouts/case_view"
  end

  def update
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
    @task = Task.new(
      case: @case,
      task_column: @case.task_columns.where(default_token: "open").first,
      is_resolved: false,
      is_deleted: false
    )

    render layout: "layouts/case_view"
  end

  def create
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

  protected

  def get_task
    @task = Task.where(case: @case).find(params[:task_id])
  end
end
