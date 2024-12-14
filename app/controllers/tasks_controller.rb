class TasksController < ApplicationController
  before_action :get_case, only: [ :index, :edit, :update ]
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

    flash[:success] = "Aufgabe erfolgreich gespeichert."
    render "tasks/edit", layout: "layouts/case_view"
  end

  protected

  def get_task
    @task = Task.where(case: @case).find(params[:task_id])
  end
end
