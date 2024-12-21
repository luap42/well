class WritingController < ApplicationController
  before_action :get_case, only: [ :new, :create ]
  before_action :get_writing_type, only: [ :new, :create ]

  def new
    @writing = WritingDraft.new(
      case: @case,
      user: current_user,
      writing_type: @writing_type,
    )

    if @writing_type.has_recipient
      @writing.title = @case.title
    end

    render layout: "layouts/case_view"
  end

  def create
  end

  protected

  def get_writing_type
    @writing_type = current_user.writing_types.find(params[:type_id])
  end
end
