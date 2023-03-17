class AddBannerColumnToBrands < ActiveRecord::Migration[5.1]
  def change
    add_column :brands, :banner_photo_url, :string
  end
end
