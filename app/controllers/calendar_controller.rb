class CalendarController < ApplicationController
  before_action :get_case, only: [ :index ]

  def global; end

  def index
    render layout: "layouts/case_view"
  end
end
