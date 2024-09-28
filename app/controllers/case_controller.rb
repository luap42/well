class CaseController < ApplicationController
  before_action :require_user_to_sign_in!

  def index; end
end
