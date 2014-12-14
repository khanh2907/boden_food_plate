class FoodDiariesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_food_diary, only: [:show, :edit, :update, :destroy, :day, :next_day, :breakdown]

  respond_to :html

  def index
    @food_diaries = FoodDiary.all
    respond_with(@food_diaries)
  end

  def show
    @meals = @food_diary.meals.where(day: @day.to_i)
  end

  def day
    @day = params[:day]
    @meals = @food_diary.meals.where(day: @day.to_i)
    render :show
  end

  def next_day
    meals_json = JSON.parse(params[:meals_json])

    Meal.delete_all("food_diary_id = #{@food_diary.id} AND day = #{params[:day].to_i}")

    meals_json.each do |meal_json|
      meal = Meal.new(name: meal_json["name"], day: meal_json["day"], food_diary_id: meal_json["food_diary_id"])
      meal_json["foods"].each do |food_id|
      food = Food.find(food_id)
      meal.foods << food unless food.nil?
      meal.save!
      end
    end

    next_day = params[:day].to_i + 1

    if next_day > 3
      redirect_to food_diary_breakdown_path(@food_diary)
    else
      redirect_to fd_day_path(@food_diary, next_day)
    end
  end

  def breakdown
    render :breakdown
  end

  def new
    @food_diary = FoodDiary.new
    respond_with(@food_diary)
  end

  def edit
  end

  def create
    @food_diary = FoodDiary.new(food_diary_params)

    participant = Participant.find_by_pid(participant_params[:pid])

    if participant.nil?
      participant = Participant.new(participant_params)
      participant.save!
    end

    @food_diary.participant = participant
    @food_diary.save
    @food_diary.diary_days.create(day:1)
    respond_with(@food_diary)
  end

  def update
    @food_diary.update(food_diary_params)
    respond_with(@food_diary)
  end

  def destroy
    @food_diary.destroy
    respond_with(@food_diary)
  end

  private
    def set_food_diary
      @food_diary = FoodDiary.find(params[:id])
    end

    def food_diary_params
      params[:food_diary].permit(:visit_number)
    end

    def participant_params
      params[:food_diary][:participant].permit(:pid, :date_of_birth, :gender)
    end
end
