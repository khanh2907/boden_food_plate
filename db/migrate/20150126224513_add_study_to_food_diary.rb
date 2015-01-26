class AddStudyToFoodDiary < ActiveRecord::Migration
  def change
    add_column :food_diaries, :study, :string
  end
end
