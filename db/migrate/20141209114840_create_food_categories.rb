class CreateFoodCategories < ActiveRecord::Migration
  def up
    create_table :food_categories do |t|
      t.string :name
      t.timestamps
    end
  end

  def down
    drop_table :food_categories
  end
end
