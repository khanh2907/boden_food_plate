class CreateMeals < ActiveRecord::Migration
  def change
    create_table :meals do |t|
      t.integer :food_dairy_id
      t.string :name

      t.timestamps
    end
  end
end
