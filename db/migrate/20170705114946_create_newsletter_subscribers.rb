class CreateNewsletterSubscribers < ActiveRecord::Migration[5.1]
  def change
    create_table :newsletter_subscribers do |t|
      t.string   :email,  null: false
      t.integer  :status, default: 1
      t.timestamps
    end
    
    add_index :newsletter_subscribers, :email, unique: true
  end
end
