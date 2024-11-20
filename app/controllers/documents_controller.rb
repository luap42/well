class DocumentsController < ApplicationController
  before_action :get_case, only: [ :index, :folder, :edit_folder, :update_folder, :new_folder,
                                   :create_folder, :document ]
  before_action :get_folder, only: [ :folder, :edit_folder, :update_folder, :document ]
  before_action :get_document, only: [ :document ]

  def index
    redirect_to folder_url(@case, @case.default_folder)
  end

  def folder
    render layout: "layouts/case_view"
  end

  def edit_folder
    render layout: "layouts/case_view"
  end

  def update_folder
    @folder.update!(name: params[:folder][:name])
    @case.touch

    flash[:success] = "Ordner erfolgreich gespeichert."
    redirect_to folder_path(@case, @folder)
  end

  def new_folder
    @folder = Folder.new(
      case: @case,
      is_default: false,
      is_protected: false,
      password: nil
    )
    render layout: "layouts/case_view"
  end

  def create_folder
    @folder = Folder.create!(
      case: @case,
      name: params[:folder][:name],
      is_default: false,
      is_protected: false,
      password: nil
    )
    @case.touch

    flash[:success] = "Ordner erfolgreich angelegt."
    redirect_to folder_path(@case, @folder)
  end

  def document
    render layout: "layouts/case_view"
  end

  protected

  def get_folder
    @folder = Folder.where(case: @case).find(params[:folder_id])
  end

  def get_document
    @document = Document.where(case: @case, folder: @folder).find(params[:document_id])
  end
end
