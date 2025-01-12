class CalendarController < ApplicationController
  before_action :get_case, only: [ :index, :edit, :update, :new, :create, :delete, :destroy ]
  before_action :get_calendar_event, only: [ :edit, :update, :delete, :destroy ]

  def global; end

  def index
    return if require_permission! :calendar_read
    render layout: "layouts/case_view"
  end

  def edit
    return if require_permission! :calendar_read
    render layout: "layouts/case_view"
  end

  def update
    return if require_permission! :calendar_write
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
    return if require_permission! :calendar_write
    @calendar_event = CalendarEvent.new(case: @case, deleted: false)
    @calendar_event.when = params[:when].to_date unless params[:when].blank?

    render layout: "layouts/case_view"
  end

  def create
    return if require_permission! :calendar_write
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

  def delete
    return if require_permission! :calendar_write
    render layout: "layouts/case_view"
  end

  def destroy
    return if require_permission! :calendar_write
    @calendar_event.update!(deleted: true)
    @case.touch
    flash[:success] = "Kalendereintrag erfolgreich gelöscht."
    redirect_to calendar_path(@case)
  end

  protected

  def get_calendar_event
    @calendar_event = CalendarEvent.where(case: @case).find(params[:event_id])
  end
end
