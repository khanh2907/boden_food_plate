class AddPidToFoodDiaries < ActiveRecord::Migration
  def change
    add_column :food_diaries, :pid, :string
  end
end
