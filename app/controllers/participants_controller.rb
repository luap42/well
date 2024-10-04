class ParticipantsController < ApplicationController
  before_action :get_case, only: [ :index ]

  def index
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
end
