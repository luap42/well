class ParticipantsController < ApplicationController
  before_action :get_case, only: [ :index, :edit, :update, :new, :create, :delete, :destroy ]
  before_action :get_participant, only: [ :edit, :update, :delete, :destroy ]

  def index
    return if require_permission! :participants_read
    @participants = @case.participants

    unless params[:name].blank?
      @participants = @participants.where("name LIKE ?", "%" + Participant.sanitize_sql_like(params[:name]) + "%")
    end

    unless params[:participant_role].blank?
      @participants = @participants.where(participant_role: ParticipantRole.find(params[:participant_role]))
    end

    @participants = @participants.order(:participant_role_id)

    render layout: "layouts/case_view"
  end

  def edit
    return if require_permission! :participants_write
    render layout: "layouts/case_view"
  end

  def update
    return if require_permission! :participants_write
    role = ParticipantRole.find(params[:participant][:participant_role])

    @participant.update!(
      participant_role: role,
      name: params[:participant][:name],
      address_field: params[:participant][:address_field],
      contact_details: params[:participant][:contact_details],
      email: params[:participant][:email],
      fax_no: params[:participant][:fax_no],
      tel_no: params[:participant][:tel_no],
      mobile_no: params[:participant][:mobile_no],
      comment: params[:participant][:comment],
      outdated: params[:participant][:outdated] == "1",
      provide_as_template: params[:participant][:provide_as_template] == "1"
    )
    @case.touch

    flash[:success] = "Beteiligte/n erfolgreich bearbeitet."

    redirect_to edit_participant_path(@case.id, @participant.id)
  end

  def new
    return if require_permission! :participants_write
    @participant = Participant.new(case: @case)
    render layout: "layouts/case_view"
  end

  def create
    return if require_permission! :participants_write
    role = ParticipantRole.find(params[:participant][:participant_role])

    @participant = Participant.create!(
      case: @case,
      participant_role: role,
      name: params[:participant][:name],
      address_field: params[:participant][:address_field],
      contact_details: params[:participant][:contact_details],
      email: params[:participant][:email],
      fax_no: params[:participant][:fax_no],
      tel_no: params[:participant][:tel_no],
      mobile_no: params[:participant][:mobile_no],
      comment: params[:participant][:comment],
      outdated: params[:participant][:outdated] == "1",
      is_deleted: false,
      provide_as_template: params[:participant][:provide_as_template] == "1"
    )
    @case.touch

    flash[:success] = "Beteiligte/n erfolgreich bearbeitet."

    redirect_to edit_participant_path(@case.id, @participant.id)
  end

  def delete
    return if require_permission! :participants_write
    render layout: "layouts/case_view"
  end

  def destroy
    return if require_permission! :participants_write
    @participant.update!(is_deleted: true)
    @case.touch

    flash[:success] = "Beteiligte/r erfolgreich gespeichert."
    redirect_to participants_path(@case)
  end

  protected

  def get_participant
    @participant = Participant.where(case: @case).find(params[:participant_id])
  end
end
