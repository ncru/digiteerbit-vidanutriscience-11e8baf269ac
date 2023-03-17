class CreatePaynamicsResponses < ActiveRecord::Migration[5.1]
  def change
    create_table :paynamics_responses do |t|
      t.string   :request_id
      t.string   :merchantid
      t.string   :response_id
      t.string   :rebill_id
      t.string   :token_id
      t.text     :signature
      t.string   :ptype
      t.string   :token_info
      t.string   :response_code
      t.text     :response_message
      t.text     :response_advise
      t.string   :processor_response_id
      t.string   :processor_response_authcode
      t.string   :timestamp
      t.timestamps
    end
    
    add_index :paynamics_responses, :request_id, unique: true
  end
end
