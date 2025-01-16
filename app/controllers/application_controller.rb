class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :require_user_to_sign_in!
  before_action :ensure_user_has_default_writing_types!

  protected

  def require_user_to_sign_in!
    return unless current_user.nil?
    return if devise_controller?
    redirect_to :new_user_session
  end

  def ensure_user_has_default_writing_types!
    return if current_user.nil?

    current_user.ensure_default_writing_types!
  end

  def get_case
    @case = Case.find(params[:case_id])
    @case.ensure_default_folder!
    @case.ensure_default_task_columns!

    nil if require_permission!(:case_read)
  end

  def require_permission!(perm)
    unless @case.user_has_permission?(current_user, perm)
      flash[:danger] = "Du hast keine Berechtigung, diese Seite aufzurufen!"
      redirect_to :root # rubocop:ignore Style/RedundantReturn
      true
    end
  end

  def require_case_manager!
    unless current_user.manager_of? @case
      flash[:danger] = "Du hast keine Berechtigung, diese Seite aufzurufen!"
      redirect_to :root # rubocop:ignore Style/RedundantReturn
      true
    end
  end

  def path_exists?(path)
    Rails.application.routes.recognize_path(path)
    true
  rescue ActionController::RoutingError
    false
  end

  def safe_path(path)
    return root_url if path.blank?
    return root_url unless path_exists? path
    URI.parse(path).path
  end
end
