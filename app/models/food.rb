class Food < ActiveRecord::Base
  belongs_to :food_category

  searchable do
    text :name
    text :food_category do
      food_category.name
    end
  end

end
