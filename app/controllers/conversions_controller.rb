class ConversionsController < ApplicationController
  before_action :is_session_over_no, only: []
  before_action :is_session_over_yes, only: [:index]
  
  def index
    @conversion = Conversion.all
    @conversion = @conversion.order(created_at: :asc).last(20)
  end  
end
