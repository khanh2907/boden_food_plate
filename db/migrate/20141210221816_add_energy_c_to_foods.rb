class AddEnergyCToFoods < ActiveRecord::Migration
  def change
    add_column :foods, :energy_c, :float
  end
end
