class CreateDiaryDays < ActiveRecord::Migration
  def change
    create_table :diary_days do |t|
      t.string :food_diary_id
      t.integer :day

      t.timestamps
    end

    remove_column :meals, :food_diary_id
    add_column :meals, :diary_day_id, :integer
  end
end
