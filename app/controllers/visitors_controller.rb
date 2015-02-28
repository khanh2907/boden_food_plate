class VisitorsController < ApplicationController

  def index
    if user_signed_in?
      redirect_to food_diaries_path
    elsif participant_signed_in?
      redirect_to participants_mode_dashboard_path
    end
  end

  def guide
  end
end
