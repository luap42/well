class PermissionsController < ApplicationController
  before_action :get_case, only: [ :index ]

  def index
    return if require_permission! :case_read
    render layout: "case_view"
  end
end
