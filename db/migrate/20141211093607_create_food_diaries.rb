class CreateFoodDiaries < ActiveRecord::Migration
  def change
    create_table :food_diaries do |t|
      t.integer :participant_id
      t.integer :visit_number

      t.timestamps
    end
  end
end
