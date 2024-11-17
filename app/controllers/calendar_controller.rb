class CalendarController < ApplicationController
  before_action :get_case, only: [ :index ]

  def global
    render layout: "layouts/case_view"
  end

  def index
    render layout: "layouts/case_view"
  end
end
