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
end
