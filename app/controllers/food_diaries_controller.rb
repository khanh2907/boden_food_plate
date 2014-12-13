class FoodDiariesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_food_diary, only: [:show, :edit, :update, :destroy, :day]

  respond_to :html

  def index
    @food_diaries = FoodDiary.all
    respond_with(@food_diaries)
  end

  def show
    respond_with(@food_diary)
  end

  def day
    @day = params[:day]
    @meals = @food_diary.meals.where(@day)
    render :show
  end

  def breakdown
    respond_with(@food_diary)
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
