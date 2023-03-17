# This custom class handles the redirection when the application 
# encounters session timeout.
class CustomFailureApp < Devise::FailureApp

  # You need to override respond to eliminate recall
  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end

  def redirect
    store_location!
    if flash[:timedout] && flash[:alert]
      flash.keep(:timedout)
      flash.keep(:alert)
    else
      flash[:alert] = i18n_message
    end
    redirect_to redirect_url
  end

  def redirect_url
    if warden_message == :timeout
      flash[:timedout] = true
      if warden_options[:scope] == :user 
        '/admin/login' 
      else
        # Remove the Timeout alert message.
        flash[:alert] = nil
        '/' 
      end
    else
      path = request.get? ? attempted_path : request.referrer
      path || scope_url
    end
  end
end