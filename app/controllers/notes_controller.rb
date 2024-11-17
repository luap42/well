class NotesController < ApplicationController
  before_action :get_case, only: [ :index ]

  def index
    render layout: "layouts/case_view"
  end
end
