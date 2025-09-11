class RemoveUniqueConstraintFromUsersPhone < ActiveRecord::Migration[8.0]
  def change
    remove_index :users, :phone
  end
end
