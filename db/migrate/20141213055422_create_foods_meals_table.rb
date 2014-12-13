class CreateFoodsMealsTable < ActiveRecord::Migration
  def change
    create_table :foods_meals do |t|
      t.references :food, :meal
    end
  end
end
