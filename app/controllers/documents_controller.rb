class DocumentsController < ApplicationController
  before_action :get_case, only: [ :index, :folder, :edit_folder, :update_folder, :new_folder,
                                   :create_folder, :document, :new_document_item,
                                   :create_document_item, :edit_document, :update_document,
                                   :new_document, :create_document ]
  before_action :get_folder, only: [ :folder, :edit_folder, :update_folder, :document,
                                     :new_document_item, :create_document_item, :edit_document,
                                     :update_document, :new_document, :create_document ]
  before_action :get_document, only: [ :document, :new_document_item, :create_document_item,
                                       :edit_document, :update_document ]

  def index
    return if require_permission! :documents_read
    redirect_to folder_url(@case, @case.default_folder)
  end

  def folder
    return if require_permission! :documents_read
    render layout: "layouts/case_view"
  end

  def edit_folder
    return if require_permission! :documents_write
    render layout: "layouts/case_view"
  end

  def update_folder
    return if require_permission! :documents_write
    @folder.update!(name: params[:folder][:name])
    @case.touch

    flash[:success] = "Ordner erfolgreich gespeichert."
    redirect_to folder_path(@case, @folder)
  end

  def new_folder
    return if require_permission! :documents_write
    @folder = Folder.new(
      case: @case,
      is_default: false,
      is_protected: false,
      password: nil
    )
    render layout: "layouts/case_view"
  end

  def create_folder
    return if require_permission! :documents_write
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
    return if require_permission! :documents_read
    render layout: "layouts/case_view"
  end

  def edit_document
    return if require_permission! :documents_write
    render layout: "layouts/case_view"
  end

  def update_document
    return if require_permission! :documents_write
    has_user = !params[:document][:user].blank?

    @document.update!(
      name: params[:document][:name],
      sent_at: params[:document][:sent_at].to_date,
      document_type: DocumentType.find(params[:document][:document_type]),
      participant: has_user ? nil : @case.participants.find(params[:document][:participant]),
      user: has_user ? User.find(params[:document][:user]) : nil
    )

    if @document.primary_item.blank? and params[:document][:file]
      uploaded_file = params[:document][:file]
      @document_item = DocumentItem.create!(
        case: @case,
        folder: @folder,
        document: @document,
        file_name: uploaded_file.original_filename,
        is_primary: true,
        is_attachment: false,
        is_transactional: false
      )
      @document_item.file.attach(uploaded_file)
    end

    @case.touch

    flash[:success] = "Dokument erfolgreich bearbeitet."
    redirect_to document_path(@case, @folder, @document)
  end

  def new_document
    return if require_permission! :documents_write
    @document = Document.new(
      case: @case,
      folder: @folder,
      sent_at: Date.today,
      is_deleted: false
    )

    render layout: "layouts/case_view"
  end

  def create_document
    return if require_permission! :documents_write
    has_user = !params[:document][:user].blank?

    @document = Document.create!(
      case: @case,
      folder: @folder,
      is_deleted: false,
      name: params[:document][:name],
      sent_at: params[:document][:sent_at].to_date,
      document_type: DocumentType.find(params[:document][:document_type]),
      participant: has_user ? nil : @case.participants.find(params[:document][:participant]),
      user: has_user ? User.find(params[:document][:user]) : nil
    )

    if @document.primary_item.blank? and params[:document][:file]
      uploaded_file = params[:document][:file]
      @document_item = DocumentItem.create!(
        case: @case,
        folder: @folder,
        document: @document,
        file_name: uploaded_file.original_filename,
        is_primary: true,
        is_attachment: false,
        is_transactional: false
      )
      @document_item.file.attach(uploaded_file)
    end

    @case.touch

    flash[:success] = "Dokument erfolgreich erstellt."
    redirect_to document_path(@case, @folder, @document)
  end

  def new_document_item
    return if require_permission! :documents_write
    @document_item = DocumentItem.new(
      case: @case,
      folder: @folder,
      document: @document
    )

    render layout: "layouts/case_view"
  end

  def create_document_item
    return if require_permission! :documents_write
    uploaded_file = params[:document_item][:file]
    @document_item = DocumentItem.create!(
      case: @case,
      folder: @folder,
      document: @document,
      file_name: uploaded_file.original_filename,
      is_primary: params[:document_item][:type].to_sym == :primary,
      is_attachment: params[:document_item][:type].to_sym == :attachment,
      is_transactional: params[:document_item][:type].to_sym == :transactional
    )
    @document_item.file.attach(uploaded_file)
    @case.touch

    flash[:success] = "Datei erfolgreich hochgeladen."
    redirect_to document_path(@case, @folder, @document)
  end

  protected

  def get_folder
    @folder = Folder.where(case: @case).find(params[:folder_id])
  end

  def get_document
    @document = Document.where(case: @case, folder: @folder).find(params[:document_id])
  end
end
