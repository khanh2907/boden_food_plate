class SearchController < ApplicationController
  def search_all
    @foods = Food.all
    render layout: false
  end

  def search_category
    @category = FoodCategory.find(params[:id])
    render layout: false
  end
end
