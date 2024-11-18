class CalendarController < ApplicationController
  before_action :get_case, only: [ :index, :edit, :update, :new, :create ]
  before_action :get_calendar_event, only: [ :edit, :update ]

  def global; end

  def index
    render layout: "layouts/case_view"
  end

  def edit
    render layout: "layouts/case_view"
  end

  def update
    @calendar_event.update!(
      title: params[:calendar_event][:title],
      when: params[:calendar_event][:when].to_date,
      comment: params[:calendar_event][:comment]
    )
    @case.touch

    flash[:success] = "Kalendereintrag erfolgreich gespeichert."
    render "calendar/edit", layout: "layouts/case_view"
  end

  def new
    @calendar_event = CalendarEvent.new(case: @case, deleted: false)
    @calendar_event.when = params[:when].to_date unless params[:when].blank?

    render layout: "layouts/case_view"
  end

  def create
    @calendar_event = CalendarEvent.create!(
      case: @case,
      deleted: false,
      title: params[:calendar_event][:title],
      when: params[:calendar_event][:when].to_date,
      comment: params[:calendar_event][:comment]
    )
    @case.touch

    flash[:success] = "Kalendereintrag erfolgreich gespeichert."
    redirect_to edit_event_path(@case, @calendar_event)
  end

  protected

  def get_calendar_event
    @calendar_event = CalendarEvent.where(case: @case).find(params[:event_id])
  end
end
