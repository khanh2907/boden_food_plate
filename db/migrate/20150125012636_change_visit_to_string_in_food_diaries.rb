class ChangeVisitToStringInFoodDiaries < ActiveRecord::Migration
  def change
  	remove_column :food_diaries, :visit_number
    add_column :food_diaries, :visit, :string
  end
end
