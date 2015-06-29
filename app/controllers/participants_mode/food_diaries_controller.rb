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

      @recent_foods = Set.new
      @food_diary.participant.food_diaries.last(10).each do |fd|
        fd.meals.each do |m|
          m.foods.each do |f|
            @recent_foods.add f
          end
        end
      end

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

    def setNutritionalValues(food_diary)
      sql = """
      select
      SUM(t.total_energy) AS total_energy,
      SUM(t.total_energy_c) AS total_energy_c,
      SUM(t.total_protein) AS total_protein,
      SUM(t.total_total_fat) AS total_total_fat,
      SUM(t.total_saturated_fat) AS total_saturated_fat,
      SUM(t.total_cholesterol) AS total_cholesterol,
      SUM(t.total_carbohydrate) AS total_carbohydrate,
      SUM(t.total_sugars) AS total_sugars,
      SUM(t.total_dietary_fibre) AS total_dietary_fibre,
      SUM(t.total_sodium) AS total_sodium
      from
      (Select s.meal_id, SUM(energy) as total_energy,
            ROUND(SUM(energy_c)::numeric, 2) as total_energy_c,
            SUM(protein) as total_protein,
            SUM(total_fat) as total_total_fat,
            SUM(saturated_fat) as total_saturated_fat,
            SUM(cholesterol) as total_cholesterol,
            SUM(carbohydrate) as total_carbohydrate,
            SUM(sugars) as total_sugars,
            SUM(dietary_fibre) as total_dietary_fibre,
            SUM(sodium) as total_sodium
            from foods as f inner join
              (SELECT food_id, meal_id FROM foods_meals where meal_id
                IN (SELECT id from meals where food_diary_id = #{food_diary.id})) as s
            ON f.id=s.food_id GROUP by s.meal_id) as t
    """
      @totals = ActiveRecord::Base.connection.exec_query(sql).to_hash.first
      @overall_total = {:total_energy => @totals['total_energy'].to_f,
                        :total_energy_c => @totals['total_energy_c'].to_f,
                        :total_protein => @totals['total_protein'].to_f,
                        :total_total_fat => @totals['total_total_fat'].to_f,
                        :total_saturated_fat => @totals['total_saturated_fat'].to_f,
                        :total_cholesterol => @totals['total_cholesterol'].to_f,
                        :total_carbohydrate => @totals['total_carbohydrate'].to_f,
                        :total_sugars => @totals['total_sugars'].to_f,
                        :total_dietary_fibre => @totals['total_dietary_fibre'].to_f,
                        :total_sodium => @totals['total_sodium'].to_f
      }

      @carb_percent = @overall_total[:total_energy] == 0 ? 0:(((@overall_total[:total_carbohydrate]/3) * 16)/(@overall_total[:total_energy]/3) * 100).to_i
      @protein_percent = @overall_total[:total_energy] == 0 ? 0:(((@overall_total[:total_protein]/3) * 16)/(@overall_total[:total_energy]/3) * 100).to_i
      @total_fat_percent = @overall_total[:total_energy] == 0 ? 0:(((@overall_total[:total_total_fat]/3) * 36)/(@overall_total[:total_energy]/3) * 100).to_i
      @sat_fat_percent = @overall_total[:total_energy] == 0 ? 0:(((@overall_total[:total_saturated_fat]/3) * 36)/(@overall_total[:total_energy]/3) * 100).to_i

      @carb_text = 'within'
      @protein_text = 'within'
      @total_fat_text = 'within'
      @sat_fat_text = 'within'

      if @carb_percent > 65
        @carb_text = 'above'
      elsif @carb_percent < 45
        @carb_text = 'below'
      end

      if @protein_percent > 25
        @protein_text = 'above'
      elsif @protein_percent < 15
        @protein_text = 'below'
      end

      if @total_fat_percent > 35
        @total_fat_text = 'above'
      elsif @total_fat_percent < 20
        @total_fat_text = 'below'
      end

      if @sat_fat_percent > 10
        @sat_fat_text = 'above'
      elsif @sat_fat_percent <= 0
        @sat_fat_text = 'below'
      end

    end

  end
end
