class RepresentmentsController < ApplicationController
  before_action :get_case, only: [ :new, :create ]

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
      reason: params[:representment][:reason],
      when: params[:representment][:when].to_date,
      priority: params[:representment][:priority] == "1"
    )

    unless to_user.manager_of?(@case)
      flash[:danger] = "WV-Empfänger muss Manager des Kurses sein."
      return render "representments/new", layout: "layouts/case_view"
    end

    to_user.representments.where(case: @case).each do |rp|
      rp.update!(dismissed: true)
    end

    @representment.save!

    flash[:success] = "WV erfolgreich angelegt"
    redirect_to root_path
  end
end
