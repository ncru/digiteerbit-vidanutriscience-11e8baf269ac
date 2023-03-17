module ApplicationHelper
  
  include ActionView::Helpers::NumberHelper

  # Set Admin Pages' title
  def title(page_title)
    content_for :title, "Vida Nutriscience | " + page_title.to_s
  end

  # Set Site pages' title
  def site_title(page_title)
    content_for :title, page_title.to_s
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:customer]
  end

  # Return a number with the specified precision and comma as delimiter.
  def format_number_with_precision(num, precision)
    return number_with_precision(num , :precision => precision, :delimiter => ",") if num.present?
  end

  # Return a number with the specified precision and no delimiter.
  def format_number_with_precision_no_delimeter(num, precision)
    return number_with_precision(num , :precision => precision, :delimiter => "") if num.present?
  end

  # Return a date in the format of Month date, year.
  def format_date(date)
    return date.blank? ? "" : date.strftime("%b %d, %Y")
  end

  # Return a date in the format specified.
  def custom_format_date(date, format)
    return date.blank? || format.blank? ? "" : date.strftime(format)
  end

  # Set the class for active sliders.
  def is_slider_active(index)
    "active" if index == 0
  end
end
