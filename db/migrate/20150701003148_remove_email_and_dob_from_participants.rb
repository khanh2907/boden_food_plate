class RemoveEmailAndDobFromParticipants < ActiveRecord::Migration
  def change
    remove_column :participants, :email
    remove_column :participants, :date_of_birth
  end
end
