module ProductHelper

  def get_remove_sku_class(id)
    sku = Sku.find(id) if id.present?
    return sku.present? ? "existing" : "dynamic"
  end
  
  def is_out_of_stock(stocks)
    "out-of-stock" if stocks == 0 || stocks < 0
  end
end
