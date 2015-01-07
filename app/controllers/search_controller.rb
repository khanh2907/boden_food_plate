class SearchController < ApplicationController
  def index
  end

  def check_participant
    participant = Participant.find_by_pid(params[:pid])

    respond_to do |format|
      format.json do
        if participant.nil?
          results = {exists: false}
        else
          results = {exists: true, pid: participant.pid, date_of_birth: participant.date_of_birth, gender: participant.gender}
        end
        render json: results
      end
    end

  end
end
