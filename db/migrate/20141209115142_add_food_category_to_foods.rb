class AddFoodCategoryToFoods < ActiveRecord::Migration
  def change
    add_column :foods, :food_category_id, :integer
  end
end
