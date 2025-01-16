class TimeRecordingController < ApplicationController
  before_action :get_case, only: [ :start, :stop, :edit, :update ]
  before_action :get_time_record, only: [ :edit, :update ]

  def global; end

  def start
    return if require_permission! :time_record_access

    if TimeRecord.has_current_for_user? current_user
      flash[:danger] = "Du erfasst gerade eine andere Zeit. Du musst die andere Zeit stoppen, " \
                       "bevor du für diesen Vorgang die Zeit starten kannst."
      return redirect_to safe_path(params[:redirect_url])
    end

    TimeRecord.create!(
      case: @case,
      user: current_user,
      begins_at: DateTime.now,
      running: true,
      comment: nil
    )

    redirect_to safe_path(params[:redirect_url])
  end

  def stop
    return if require_permission! :time_record_access

    unless TimeRecord.has_current_for_case_and_user? @case, current_user
      flash[:danger] = "Deine Zeiterfassung läuft gerade gar nicht und kann daher auch nicht gestoppt werden."
      return redirect_to safe_path(params[:redirect_url])
    end

    time_record = TimeRecord.current_for_case_and_user @case, current_user
    time_record.stop!

    redirect_to safe_path(params[:redirect_url])
  end

  def edit
    render layout: "layouts/case_view"
  end

  def update
    begins_at = params[:time_record][:begins_at].in_time_zone(Rails.configuration.time_zone)
    ends_at = params[:time_record][:begins_at].in_time_zone(Rails.configuration.time_zone)

    if begins_at > ends_at
      ends_at = begins_et
    end

    @time_record.update!(
      comment: params[:time_record][:comment],
      begins_at: begins_at,
      ends_at: ends_at
    )

    flash[:success] = "Zeiteintragung wurde erfolgreich angepasst"

    redirect_to show_case_url(@case)
  end

  protected

  def get_time_record
    @time_record = @case.time_records.where(user: current_user).find(params[:time_record_id])
  end
end
