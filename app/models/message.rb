class Message < ApplicationRecord

  scope :for_datatables, -> {
    select("id,name,email,created_at")
  }

  scope :last_30days_messages, -> {
    where("created_at::date >= (current_timestamp - interval '30 days')::date")
  }

  scope :latest_messages, -> {
    select("id,name,email,mobile,content,created_at")
      .order("id DESC")
      .limit(5)
  }

  validates :name, presence: true, length: {:minimum => 1, :maximum => 50}
  validates :email, presence: true, length: {:minimum => 1, :maximum => 50}
  validates :content, presence: true

end
