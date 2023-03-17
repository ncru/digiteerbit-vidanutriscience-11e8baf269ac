class AddColumnToDhlRepsonseValues < ActiveRecord::Migration[5.1]
  def change
    add_column :dhl_response_values, :pickup_date, :date
  end
end
