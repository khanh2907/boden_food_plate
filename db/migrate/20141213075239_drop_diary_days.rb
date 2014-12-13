class DropDiaryDays < ActiveRecord::Migration
  def change
    drop_table :diary_days
    remove_column :meals, :diary_day_id
    add_column :meals, :day, :integer
  end
end
