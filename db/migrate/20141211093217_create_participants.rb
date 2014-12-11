class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.string :pid
      t.date :date_of_birth
      t.integer :gender

      t.timestamps
    end
  end
end
