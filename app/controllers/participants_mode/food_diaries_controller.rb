module ParticipantsMode
  class FoodDiariesController < ApplicationController
    before_filter :authenticate_participant!
    before_action :set_food_diary, only: [:show, :edit, :update, :day, :next_day, :breakdown]
    after_action :verify_authorized

    def show
      @hide_layout = true
      @meals = @food_diary.meals.where(day: @day.to_i)
    end

    def day
      @hide_layout = true
      @day = params[:day]
      @meals = @food_diary.meals.where(day: @day.to_i)
      render :show
    end

    def next_day
      @hide_nav = true
      meals_json = JSON.parse(params[:meals_json])

      meals_json.each do |meal_json|
        meal = Meal.find_by(name: meal_json["name"], day: meal_json["day"], food_diary_id: meal_json["food_diary_id"])
        meal.foods.delete_all
        meal_json["foods"].each do |food_id|
          food = Food.find(food_id)
          meal.foods << food unless food.nil?
          meal.save!
        end
      end

      next_day = params[:day].to_i + 1

      if next_day > 3
        redirect_to participants_mode_food_diary_breakdown_path(@food_diary)
      else
        redirect_to participants_mode_fd_day_path(@food_diary, next_day)
      end
    end

    def edit
    end

    def update
      @food_diary.update(food_diary_params)
      respond_with(@food_diary)
    end

    def breakdown
      @hide_nav = true
      @participant = @food_diary.participant
      setNutritionalValues(@food_diary)
    end

    private
    def set_food_diary
      @food_diary = FoodDiary.find(params[:id])
      authorize @food_diary
    end

    def food_diary_params
      params[:food_diary].permit(:visit, :study, :participant_id)
    end

    def pundit_user
      current_participant
    end

  end
end
