class SiteController < ApplicationController
  layout 'site'

  include CustomerCart
  include GlobalObjects

  protected
    def redirect_if_not_signed_in
      unless customer_signed_in?
        session[:site_return_to] = request.url
        redirect_to new_customer_session_path, alert: "You need to sign in or sign up before continuing."
      end
    end
  private
    def set_cache_headers
      response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
      response.headers["Pragma"] = "no-cache"
      response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    end
end
