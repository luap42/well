class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :require_user_to_sign_in!

  protected
  def require_user_to_sign_in!
    return unless current_user.nil?
    return if devise_controller?
    redirect_to :new_user_session
  end

  def get_case
    @case = Case.find(params[:case_id])
    @case.ensure_default_folder!
    @case.ensure_default_task_columns!
  end
end
