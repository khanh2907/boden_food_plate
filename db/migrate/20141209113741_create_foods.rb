class CreateFoods < ActiveRecord::Migration
  def change
    create_table :foods do |t|
      t.string :serving_size
      t.float :serving_weight
      t.float :energy
      t.float :protein
      t.float :total_fat
      t.float :saturated_fat
      t.float :cholesterol
      t.float :carbohydrate
      t.float :sugars
      t.float :dietary_fibre
      t.float :sodium

      t.timestamps
    end
  end
end
