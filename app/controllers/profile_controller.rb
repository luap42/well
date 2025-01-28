class ProfileController < ApplicationController
  before_action :get_writing_type, only: [ :edit_writing_type, :update_writing_type ]
  def edit; end

  def update
    current_user.update!(
      full_name: params[:user][:full_name],
      shortcode: params[:user][:shortcode],
      time_billing_factor_in_ct: params[:user][:time_billing_factor_in_ct].to_i
    )

    flash[:success] = "Profil erfolgreich bearbeitet."

    redirect_to edit_profile_url
  end

  def writing_types; end

  def edit_writing_type; end

  def update_writing_type
    @writing_type.update!(
      title: params[:writing_type][:title],
      has_recipient: params[:writing_type][:has_recipient] == "1",
      has_cosigning_required: params[:writing_type][:has_cosigning_required] == "1",
      is_enabled: params[:writing_type][:is_enabled] == "1",
    )

    @writing_type.template.attach(params[:writing_type][:template]) unless params[:writing_type][:template].blank?

    flash[:success] = "Dokumententyp erfolgreich gespeichert."

    redirect_to edit_writing_types_url
  end

  protected

  def get_writing_type
    @writing_type = WritingType.unscoped.where(user: current_user).find(params[:writing_type_id])
  end
end
