class SetDefaultForFriendshipStatus < ActiveRecord::Migration[5.2]
  def change
    change_column :friendships, :status, :integer, default: 0
  end
end
