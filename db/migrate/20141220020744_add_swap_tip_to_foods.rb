class AddSwapTipToFoods < ActiveRecord::Migration
  def change
    add_column :foods, :swap_tip, :string
  end
end
