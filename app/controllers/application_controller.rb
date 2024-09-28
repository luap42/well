class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :require_user_to_sign_in!

  def index; end

  protected

  def require_user_to_sign_in!
    return unless current_user.nil?
    return if devise_controller?
    redirect_to :new_user_session
  end
end
