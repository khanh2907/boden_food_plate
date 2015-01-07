class ChangeSwapTipToText < ActiveRecord::Migration
  def change
    change_column :foods, :swap_tip, :text
  end
end
