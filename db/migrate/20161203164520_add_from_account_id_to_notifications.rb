class AddFromAccountIdToNotifications < ActiveRecord::Migration[5.0]
  def up
    add_column :notifications, :from_account_id, :integer
  end

  def down
    remove_column :notifications, :from_account_id
  end
end
