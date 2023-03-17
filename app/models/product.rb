class Product < ApplicationRecord

  include Slug
  include ActionView::Helpers::NumberHelper
  include ApplicationHelper

  belongs_to :division
  has_many :skus, -> { order("id") }, dependent: :destroy
  has_many :product_reviews, -> { order("id desc") }, dependent: :destroy
  has_many :product_faqs, -> { order("id desc") }, dependent: :destroy

  scope :for_datatables, -> {
    select("p.id,(case when sku.photos[1] is null then 'https://vidanutriscience.s3-ap-southeast-1.amazonaws.com/assets/default-slider.jpg' else sku.photos[1] end) as photo_url,(case when sku.new=1 then 'New' else '' end) as is_new,(case when sku.featured=1 then 'Featured' else '' end) as is_featured,p.name as product_name,b.name as brand_name,c.name as category_name,p.status")
      .from("products p JOIN (select DISTINCT ON (product_id) product_id,id,photos,new,featured from skus order by product_id,id) sku ON p.id=sku.product_id JOIN brands b ON p.brand_id=b.id JOIN divisions c ON p.division_id=c.id")
  }

  scope :active_products_count,-> {
    select("p.id")
      .from("products p JOIN (select DISTINCT ON (product_id) product_id,id,photos,new,featured from skus order by product_id,id) sku ON p.id=sku.product_id JOIN brands b ON p.brand_id=b.id JOIN divisions c ON p.division_id=c.id")
      .where("p.status=1")
  }


  scope :get_details, ->(id) {
    select("id,name,description")
      .where("id = ?", id)
  }

  validates :name,
    presence: { message: "is required."},
    uniqueness: { message: "<b>%{value}</b> has already been taken."}
  validates :brand_id, presence: { message: "is required."}
  validates :division_id, presence: { message: "is required."}
  validates :skus, presence: { message: "should be defined."}

  accepts_nested_attributes_for :skus, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :product_faqs, allow_destroy: true, reject_if: :all_blank

  # def return_items(number_of_items_to_return)
  #   self.total_stocks += number_of_items_to_return
  #   self.save
  # end
  #
  # def deduct_from_stocks(number_of_items_to_get)
  #   self.total_stocks -= number_of_items_to_get
  #   self.save
  # end
  #
  # def compute_stocks
  #   self.total_stocks = skus.sum("stocks")
  #   self.save
  # end

  before_create :remove_empty_elements
  before_update :remove_empty_elements

  def remove_empty_elements
    self.sub_division_ids = self.sub_division_ids.delete_if(&:blank?)
    self.restricted_country_codes = self.restricted_country_codes.delete_if(&:blank?)
  end

  def rating
    product_reviews.average(:rating)
  end

  def rating_details
    count = product_reviews.count
    count > 0 ?
      "#{format_number_with_precision_no_delimeter(self.rating, 2)} stars out of #{ActionController::Base.helpers.pluralize(count, 'review')}."
      : 'No reviews yet.'
  end

  def url
    "/shop/#{self.division.name.parameterize}/#{self.slug}"
  end
end
