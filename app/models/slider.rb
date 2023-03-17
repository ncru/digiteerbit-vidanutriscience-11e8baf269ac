class Slider < ApplicationRecord

  scope :homepage_sliders, -> {
    select("title, excerpt, photo_url, 
      (CASE WHEN mobile_photo_url = '' OR mobile_photo_url IS NULL THEN photo_url ELSE mobile_photo_url END) AS mobile_photo_url, 
      (CASE WHEN external_link = '' OR external_link IS NULL THEN '' ELSE external_link END) AS external_link")
    .where("status = 1")
    .where("photo_url != ''")
    .where("photo_url IS NOT NULL")
    .order("id")
  }

  scope :available_sliders, -> {
    select("id, title, excerpt,
      (CASE WHEN photo_url = '' OR photo_url IS NULL THEN 'https://vidanutriscience.s3-ap-southeast-1.amazonaws.com/assets/default-slider.jpg' ELSE photo_url END) AS photo_url,
      (CASE WHEN mobile_photo_url = '' OR mobile_photo_url IS NULL THEN 'https://vidanutriscience.s3-ap-southeast-1.amazonaws.com/assets/default-slider.jpg' ELSE mobile_photo_url END) AS mobile_photo_url, status, external_link")
    .order("id")
  }

  def is_disabled
    status? ? "" : "disabled"
  end
end
