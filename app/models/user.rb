class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable,
         :validatable

  scope :exclude_self,->(id) {
    where("users.id!=?", id)
    .where("users.role_id!=1")
  }

  scope :all_users, -> {
    where("users.role_id!=1")
  }

  scope :for_datatables,->(id) {
    select("u.id,(case when u.photo_file_name is null then 'https://vidanutriscience.s3-ap-southeast-1.amazonaws.com/assets/avatar.svg' else concat('https://vidanutriscience.s3-ap-southeast-1.amazonaws.com/assets/',u.id,'/',u.photo_file_name) end) as photo_file_name,concat(u.first_name,' ',u.last_name) as fullname,u.email,u.role_id,r.name as role_name,u.last_sign_in_at as lastsigninat,u.sign_in_count as signincount")
      .from("users u join roles r on u.role_id = r.id")
      .where("u.id!=?", id)
      .where("u.role_id!=1")
  }

  has_attached_file :photo, {
    :default_url => "/assets/avatar.svg",
    :path => "assets/:id/:basename.:extension"
  }.merge(PAPERCLIP_STORAGE_OPTIONS)

  validates :first_name, presence: { message: "is required."}
  validates :last_name, presence: { message: "is required."}
  validates_attachment :photo, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }

  before_create :set_defaults

  def generate_password
    self.password = SecureRandom.hex(8)
  end

  def is_super_admin?
    return self.role_id == 1
  end

  def is_admin?
    return self.role_id == 2
  end

  def is_manager?
    return self.role_id == 3
  end

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
end
