class Food < ActiveRecord::Base
  belongs_to :food_category
  has_and_belongs_to_many :meals

  searchable do
    text :name
    text :food_category do
      food_category.name
    end
  end

end
