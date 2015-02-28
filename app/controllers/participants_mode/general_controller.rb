module ParticipantsMode
  class GeneralController < ApplicationController
    before_filter :authenticate_participant!

    respond_to :html, :json

    def index
      @food_diaries = current_participant.food_diaries
    end


    private

    def secure_params
      params.require(:participant).permit(:pid, :gender, :date_of_birth, :group, :email)
    end

  end
end


