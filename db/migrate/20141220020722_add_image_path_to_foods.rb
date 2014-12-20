class AddImagePathToFoods < ActiveRecord::Migration
  def change
    add_column :foods, :image_path, :string
  end
end
