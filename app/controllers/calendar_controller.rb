class CalendarController < ApplicationController
  before_action :get_case, only: [ :index, :edit, :update ]
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
      when: params[:calendar_event][:when].to_date
    )

    flash[:success] = "Kalendereintrag erfolgreich gespeichert."
    redirect_to calendar_path(@case, start_date: @calendar_event.when)
  end

  protected

  def get_calendar_event
    @calendar_event = CalendarEvent.where(case: @case).find(params[:event_id])
  end
end
