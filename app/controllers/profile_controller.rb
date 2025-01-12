class ProfileController < ApplicationController
  def edit; end

  def update
    current_user.update!(
      full_name: params[:user][:full_name],
      shortcode: params[:user][:shortcode]
    )

    flash[:success] = "Profil erfolgreich bearbeitet."

    redirect_to edit_profile_url
  end
end
