class Customer < ApplicationRecord

  has_many :carts, dependent: :destroy
  has_many :orders, -> { 
      where("orders.order_status_id IS NOT NULL")
      .order("id desc") 
    }, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :omniauthable, :omniauth_providers => [:facebook]
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable,
         :validatable

  scope :exclude_self,->(id) {
    where("id!=?", id)
  }

  has_attached_file :photo, {
    :default_url => "/assets/avatar.svg",
    :path => "assets/:id/:basename.:extension"
  }.merge(PAPERCLIP_STORAGE_OPTIONS)

  validates            :first_name, presence: true
  validates            :last_name, presence: true
  validates_attachment :photo, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }

  before_create :set_defaults

  def full_name
    first_name.to_s + " " + middle_name.to_s + " " + last_name.to_s
  end

  def set_defaults
    self.reset_password_token = SecureRandom.urlsafe_base64
  end

  def get_html_credentials
    %Q[
      <div style="color: rgb(0, 0, 0); font-family: helvetica, arial, sans-serif;">
        Username: <strong>#{self.email}</strong>
      </div>
      <div style="color: rgb(0, 0, 0); font-family: helvetica, arial, sans-serif;">
        Password: <strong>#{self.password}</strong>
      </div>
    ]
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |customer|
      customer.email = auth.info.email
      customer.password = Devise.friendly_token[0,20]

      if auth.info.first_name.present? && auth.info.last_name.present?
        customer.first_name = auth.info.first_name
        customer.last_name = auth.info.last_name
      else
        if auth.info.name.present?
          first_name = auth.info.name.split(" ")[0]
          last_name = auth.info.name.split(" ")[auth.info.name.split(" ").size - 1]

          customer.first_name = first_name
          customer.last_name = last_name
        end
      end

      customer.photo_file_name = auth.info.image
    end
  end

  def shipping_address
    self.customer_shipping_detail.blank? ? "-" : self.customer_shipping_detail.shipping_address
  end

  def billing_address
    self.customer_billing_detail.blank? ? "-" : self.customer_billing_detail.billing_address
  end
end
