class RepresentmentsController < ApplicationController
  before_action :get_case, only: [ :new, :create, :create_for_days, :clear, :clear_and_step, :step ]

  def new
    @representment = Representment.new(case: @case)
    render layout: "layouts/case_view"
  end

  def create
    to_user = User.find(params[:representment][:to_user])

    @representment = Representment.new(
      case: @case,
      to_user: to_user,
      from_user: current_user,
      reason: (params[:representment][:reason].blank? ? "zur weiteren Bearbeitung" : params[:representment][:reason]),
      when: params[:representment][:when].to_date,
      priority: params[:representment][:priority] == "1",
      dismissed: false
    )

    unless to_user.manager_of?(@case)
      flash[:danger] = "WV-Empfänger muss Manager des Kurses sein."
      return render "representments/new", layout: "layouts/case_view"
    end

    Representment.where(case: @case, to_user: current_user).update_all(dismissed: true)

    @representment.save!
    @case.touch

    flash[:success] = "WV erfolgreich angelegt."
    redirect_to root_path
  end

  def create_for_days
    unless current_user.manager_of?(@case)
      flash[:danger] = "WV-Empfänger muss Manager des Kurses sein."
      return redirect_to show_case_path(@case)
    end

    Representment.where(case: @case, to_user: current_user).update_all(dismissed: true)

    @representment = Representment.create!(
      case: @case,
      to_user: current_user,
      from_user: current_user,
      reason: "zur weiteren Bearbeitung",
      when: params[:days].to_i.days.from_now,
      priority: false,
      dismissed: false
    )

    @case.touch

    flash[:success] = "WV erfolgreich angelegt."
    redirect_to root_path
  end

  def clear
    Representment.where(case: @case, to_user: current_user).update_all(dismissed: true)
    @case.touch

    flash[:success] = "Vorgang erfolgreich weggelegt."
    redirect_to root_path
  end

  def step
    if @case.case_status.next_step
      @case.update!(case_status: @case.case_status.next_step)
      @case.touch
    end

    flash[:success] = "Vorgang erfolgreich als #{@case.case_status.title} markiert."
    redirect_to show_case_path(@case)
  end

  def clear_and_step
    Representment.where(case: @case, to_user: current_user).update_all(dismissed: true)

    if @case.case_status.next_step
      @case.update!(case_status: @case.case_status.next_step)
      @case.touch
    end

    flash[:success] = "Vorgang erfolgreich als #{@case.case_status.title} markiert und weggelegt."
    redirect_to root_path
  end
end
