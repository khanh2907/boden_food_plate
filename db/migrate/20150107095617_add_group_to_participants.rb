class AddGroupToParticipants < ActiveRecord::Migration
  def change
    add_column :participants, :group, :string
  end
end
