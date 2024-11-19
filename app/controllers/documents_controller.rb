class DocumentsController < ApplicationController
  before_action :get_case, only: [ :index, :folder, :edit_folder, :update_folder ]
  before_action :get_folder, only: [ :folder, :edit_folder, :update_folder ]

  def index
    redirect_to folder_url(@case, @case.folders.where(is_default: true).first)
  end

  def folder
    render layout: "layouts/case_view"
  end

  def edit_folder
    render layout: "layouts/case_view"
  end

  def update_folder
    @folder.update!(name: params[:folder][:name])
    flash[:success] = "Ordner erfolgreich gespeichert."
    redirect_to folder_path(@case, @folder)
  end

  protected

  def get_folder
    @folder = Folder.where(case: @case).find(params[:folder_id])
  end
end
