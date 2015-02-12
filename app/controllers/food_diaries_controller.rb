require 'csv'
class FoodDiariesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_food_diary, only: [:show, :edit, :update, :destroy, :day, :next_day, :breakdown]

  respond_to :html

  def index
    @food_diaries = FoodDiary.all
    @studies = FoodDiary.all.distinct.pluck(:study)
    respond_to do |format|
      format.html do
        if session[:management_on]
          render 'management'
        end
      end
      format.csv {send_data generate_totals_csv, :filename => "boden_food_diaries_#{DateTime.now.strftime('%d%m%Y')}.csv"}
      format.xls {send_data generate_totals_csv(col_sep: "\t"), :filename => "boden_food_diaries_#{DateTime.now.strftime('%d%m%Y')}.xls"}
    end
  end

  def set_management
    session[:management_on] = session[:management_on].nil? ? 1 : nil
    redirect_to food_diaries_path
  end

  def delete_selected
    delete_food_diaries = params[:delete_food_diaries]
    unless delete_food_diaries.nil?
      delete_keys = delete_food_diaries.keys
      FoodDiary.where(id: delete_keys).delete_all
    end
    redirect_to food_diaries_path
  end

  def delete_study
    study_name = params[:study_name]
    FoodDiary.where(study: study_name).delete_all
    redirect_to food_diaries_path
  end

  def export_study
    study_name = params[:study_name]
    respond_to do |format|
      format.csv {send_data generate_totals_csv_by_study(study_name), :filename => "#{study_name}_#{DateTime.now.strftime('%d%m%Y')}.csv"}
      format.xls {send_data generate_totals_csv_by_study(study_name, {col_sep: "\t"}), :filename => "#{study_name}_#{DateTime.now.strftime('%d%m%Y')}.xls"}
    end
  end

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
      redirect_to food_diary_breakdown_path(@food_diary)
    else
      redirect_to fd_day_path(@food_diary, next_day)
    end
  end

  def search_all
    @foods = Food.all
    render layout: false
  end

  def search_category
    @category = FoodCategory.find(params[:id])
    render layout: false
  end

  def breakdown
    @hide_nav = true
    @participant = @food_diary.participant
    setNutritionalValues(@food_diary)
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
    default_plates = ['Breakfast', 'Snack', 'Lunch', 'Snack', 'Supper', 'Dinner']
    (1..3).each do |day|
      default_plates.each do |plate|
        @food_diary.meals.create(day: day, name: plate)
      end
    end
    redirect_to "#{food_diary_path(@food_diary)}/1"
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
    params[:food_diary].permit(:visit, :study)
  end

  def participant_params
    params[:food_diary][:participant].permit(:pid, :date_of_birth, :gender, :group)
  end

  def generate_totals_csv_by_study(study_name, options = {})
    sql = """
    select parts.pid as participant_id, totals.fd_study as study, parts.group, parts.gender, parts.date_of_birth, totals.visit, totals.fd_date as date ,totals.total_energy,
      totals.total_energy_c,
      totals.total_protein,
      totals.total_total_fat,
      totals.total_saturated_fat,
      totals.total_cholesterol,
      totals.total_carbohydrate,
      totals.total_sugars,
      totals.total_dietary_fibre,
      totals.total_sodium from
      (select s.food_diary_id, s.participant_id, s.visit, s.fd_date, s.fd_study, SUM(energy) as total_energy,
      ROUND(SUM(energy_c)::numeric, 2) as total_energy_c,
      SUM(protein) as total_protein,
      SUM(total_fat) as total_total_fat,
      SUM(saturated_fat) as total_saturated_fat,
      SUM(cholesterol) as total_cholesterol,
      SUM(carbohydrate) as total_carbohydrate,
      SUM(sugars) as total_sugars,
      SUM(dietary_fibre) as total_dietary_fibre,
      SUM(sodium) as total_sodium from foods as f
      right outer join
        (select food_id, fdm.food_diary_id, fdm.visit, fdm.participant_id, fdm.fd_date, fdm.fd_study from foods_meals as fm
        right outer join
          (select m.food_diary_id, fd.visit, fd.participant_id, m.id as meal_id, fd.created_at as fd_date, fd.study as fd_study
          from food_diaries as fd
          inner join meals as m
          on m.food_diary_id=fd.id) as fdm
        on fdm.meal_id = fm.meal_id) as s
      on f.id = s.food_id group by food_diary_id, s.fd_study, visit, participant_id, fd_date) as totals
      inner join participants as parts on totals.participant_id=parts.id where totals.fd_study = '#{study_name}';
    """

    totals = ActiveRecord::Base.connection.exec_query(sql).to_hash

    CSV.generate(options) do |csv|
      csv << totals[0].keys.map!(&:titleize)
      totals.each do |fd|
        gender = Participant.genders.select{|key, val| key if val == fd['gender'].to_i }.first[0]
        fd['gender'] = gender
        csv << fd.values
      end
    end

  end

  def generate_totals_csv(options = {})
    sql = '''
      select parts.pid as participant_id, parts.group, parts.gender, parts.date_of_birth, totals.visit, totals.fd_date as date ,totals.total_energy,
      totals.total_energy_c,
      totals.total_protein,
      totals.total_total_fat,
      totals.total_saturated_fat,
      totals.total_cholesterol,
      totals.total_carbohydrate,
      totals.total_sugars,
      totals.total_dietary_fibre,
      totals.total_sodium from
      (select s.food_diary_id, s.participant_id, s.visit, s.fd_date, SUM(energy) as total_energy,
      ROUND(SUM(energy_c)::numeric, 2) as total_energy_c,
      SUM(protein) as total_protein,
      SUM(total_fat) as total_total_fat,
      SUM(saturated_fat) as total_saturated_fat,
      SUM(cholesterol) as total_cholesterol,
      SUM(carbohydrate) as total_carbohydrate,
      SUM(sugars) as total_sugars,
      SUM(dietary_fibre) as total_dietary_fibre,
      SUM(sodium) as total_sodium from foods as f
      right outer join
        (select food_id, fdm.food_diary_id, fdm.visit, fdm.participant_id, fdm.fd_date from foods_meals as fm
        right outer join
          (select m.food_diary_id, fd.visit, fd.participant_id, m.id as meal_id, fd.created_at as fd_date
          from food_diaries as fd
          inner join meals as m
          on m.food_diary_id=fd.id) as fdm
        on fdm.meal_id = fm.meal_id) as s
      on f.id = s.food_id group by food_diary_id, visit, participant_id, fd_date) as totals
      inner join participants as parts on totals.participant_id=parts.id;
    '''
    totals = ActiveRecord::Base.connection.exec_query(sql).to_hash

    CSV.generate(options) do |csv|
      csv << totals[0].keys.map!(&:titleize)
      totals.each do |fd|
        gender = Participant.genders.select{|key, val| key if val == fd['gender'].to_i }.first[0]
        fd['gender'] = gender
        csv << fd.values
      end
    end

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
