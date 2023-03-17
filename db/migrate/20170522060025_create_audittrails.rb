class CreateAudittrails < ActiveRecord::Migration[5.0]
  def change
    create_table :audittrails, force: true do |t|
      t.string   :module, null: false, limit: 100
      t.text     :event_description, null: false
      t.inet     :ip_address, null: false
      t.string   :modified_by_email, null: false
      t.string   :modified_by_name, null: false
      t.timestamps
    end
  end
end
