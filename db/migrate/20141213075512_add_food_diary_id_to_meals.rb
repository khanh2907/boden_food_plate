class AddFoodDiaryIdToMeals < ActiveRecord::Migration
  def change
    add_column :meals, :food_diary_id, :integer
  end
end
