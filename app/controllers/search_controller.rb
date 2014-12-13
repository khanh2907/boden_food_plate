class SearchController < ApplicationController
  def index
  end

  def query
    # Get the search terms from the q parameter and do a search
    # as we seen in the previous part of the article.
    search = Food.search do
      fulltext params[:q] # Full text search
    end

    respond_to do |format|
      format.json do
        # Create an array from the search results.
        results = search.results.map do |food|
          # Each element will be a hash containing only the title of the article.
          # The title key is used by typeahead.js.
          { name: food.name }
        end
        render json: results
      end
    end
  end

  def query_participant
    search = Participant.search do
      fulltext params[:q]
    end

    respond_to do |format|
      format.json do
        results = search.results.map do |p|
          { pid: p.pid, date_of_birth: p.date_of_birth, gender: p.gender }
        end
        render json: results
      end
    end
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
