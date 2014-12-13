class ChangeFoodDairyToFoodDiaryInMeals < ActiveRecord::Migration
  def change
    rename_column :meals, :food_dairy_id, :food_diary_id
  end
end
