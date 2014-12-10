class FoodCategoriesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @food_categories = FoodCategory.all
  end

  def show
    @food_category = FoodCategory.find(params[:id])
  end
end
