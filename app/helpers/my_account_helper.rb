module MyAccountHelper
  
  # Check if a link is active based from the current url.
  def active?(url)
    return request.url.to_s.include?(url.to_s) ? 'active' : ''
  end
end
