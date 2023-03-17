class NewsletterSubscriber < ApplicationRecord

  scope :active_subscribers, -> {
    where("status=1")
  }

  scope :available_subscribers, -> {
    where("status=1")
    .order("id DESC")
  }

  scope :for_datatables,-> {
    select("ns.id, 
      (CASE WHEN c.photo_file_name IS NULL THEN 'https://vidanutriscience.s3-ap-southeast-1.amazonaws.com/assets/avatar.svg' ELSE CONCAT('https://vidanutriscience.s3-ap-southeast-1.amazonaws.com/assets/',c.id,'/',c.photo_file_name) END) AS photo_file_name, ns.email, CONCAT(c.first_name,' ',c.last_name) AS fullname, ns.created_at")
    .from("newsletter_subscribers ns LEFT OUTER JOIN customers c ON ns.email = c.email")
    .order("ns.id DESC")
  }

  validates :email,
    presence: { message: "is required" },
    uniqueness: { 
      message: "already exists" }
      
  validates_format_of :email, with: Devise::email_regexp
end
