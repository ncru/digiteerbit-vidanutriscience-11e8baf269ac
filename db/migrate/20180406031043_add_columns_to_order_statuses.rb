class AddColumnsToOrderStatuses < ActiveRecord::Migration[5.1]
  def change
    change_column :order_statuses, :level, :integer, default: 0
    add_column :order_statuses, :dhl_service_id, :integer
    add_column :order_statuses, :courier_id, :integer, default: -1
  end
end
