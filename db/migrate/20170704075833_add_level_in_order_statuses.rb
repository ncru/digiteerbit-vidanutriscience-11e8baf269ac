class AddLevelInOrderStatuses < ActiveRecord::Migration[5.1]
  def change
    add_column :order_statuses, :level, :integer
  end
end
