class DocumentsController < ApplicationController
  before_action :get_case, only: [ :index, :folder ]
  before_action :get_folder, only: [ :folder ]

  def index
    redirect_to folder_url(@case, @case.folders.where(is_default: true).first)
  end

  def folder
    render layout: "layouts/case_view"
  end

  protected

  def get_folder
    @folder = Folder.where(case: @case).find(params[:folder_id])
  end
end
