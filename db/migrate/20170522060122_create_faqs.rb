class CreateFaqs < ActiveRecord::Migration[5.0]
  def change
    create_table :faqs do |t|
      t.string   :title, null: false
      t.text     :question, null: false
      t.text     :answer, null: false
      t.integer  :status
      t.timestamps
    end
  end
end
