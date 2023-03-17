require 'sendgrid-ruby'
require 'json'
include SendGrid

module SendGridMailer

  def send_registration_email(user)
    mail             = SendGrid::Mail.new
    mail.from        = SendGrid::Email.new(email: 'info@vidanutriscience.com', name: 'Vida Nutriscience, Inc.')
    mail.subject     = 'Vida Nutriscience Account Creation'
    mail.template_id = '7886f05e-2347-4135-9d9d-d747cf3e9902'
    mail.add_category(SendGrid::Category.new(name: 'Admin Account Creation'))
    mail.add_content(SendGrid::Content.new(type: 'text/html', value: user.get_html_credentials))

    # Set the recipients. You can specify recipient type to: 'to', 'cc' or 'bcc'.
    recipients = [
      {"email"=>user.email, "name"=>user.full_name, "type"=>"to"}
    ]

    # Set the subtitution values to the template keys.
    substitutions = [
      {"key"=>"-logoUrl-", "value"=>"https://vidanutriscience.s3-ap-southeast-1.amazonaws.com/production/assets/logo-vida-9cdf1cbb104dbec8929423fbb48c72f790c33a334086479ed68170d3c451858b.png"},
      {"key"=>"-fullname-", "value"=>user.full_name},
      {"key"=>"-heading-", "value"=>"We have created an account for you in https://vidanutriscience.herokuapp.com. Please use the credentials below when logging-in to the system. We have generated a temporary password for you, we strongly encourage you to change them on Account Settings once you have logged in."},
      {"key"=>"-linkUrl-", "value"=>"https://vidanutriscience.herokuapp.com/admin/login"},
      {"key"=>"-footer-", "value"=>"Thank you and have a great day!"}
    ]

    response = SGMailer.new.send_mail(mail, recipients, substitutions)

    if (response.status_code.to_i).between?(200, 299)
      puts "Sent admin user registration email with Response Code: #{response.status_code}"
    else
      puts "Unable to send admin user registration email with Response Code: #{response.status_code}"
    end
  end

  def send_customer_registration_email(customer)
    mail             = SendGrid::Mail.new
    mail.from        = SendGrid::Email.new(email: 'info@vidanutriscience.com', name: 'Vida Nutriscience, Inc.')
    mail.subject     = 'Vida Nutriscience Account Creation'
    mail.template_id = 'dbf84b05-3dc1-4568-9ac6-d0e66cb14d9d'
    mail.add_category(SendGrid::Category.new(name: 'Customer Account Creation'))
    mail.add_content(SendGrid::Content.new(type: 'text/html', value: '<div></div>'))

    # Set the recipients. You can specify recipient type to: 'to', 'cc' or 'bcc'.
    recipients = [
      {"email"=>customer.email, "name"=>customer.full_name, "type"=>"to"}
    ]

    # Set the subtitution values to the template keys.
    substitutions = [
      {"key"=>"-firstname-", "value"=>customer.first_name}
    ]

    response = SGMailer.new.send_mail(mail, recipients, substitutions)

    if (response.status_code.to_i).between?(200, 299)
      puts "Sent customer registration email with Response Code: #{response.status_code}"
    else
      puts "Unable to send customer registration email with Response Code: #{response.status_code}"
    end
  end
  
  def send_order_confirmation_email(order, subtotal)
    mail             = SendGrid::Mail.new
    mail.from        = SendGrid::Email.new(email: 'info@vidanutriscience.com', name: 'Vida Nutriscience, Inc.')
    mail.subject     = 'Vida Nutriscience Order Confirmation'
    mail.template_id = 'a31db2d1-295d-4a7a-bfa0-269acaa4d0df'
    mail.add_category(SendGrid::Category.new(name: 'Order Confirmation'))
    mail.add_content(SendGrid::Content.new(type: 'text/html', value: order.get_html_order_details))

    # Set the recipients. You can specify recipient type to: 'to', 'cc' or 'bcc'.
    recipients = [
      {"email"=>order.customer.email, "name"=>order.customer.full_name, "type"=>"to"}
    ]

    # Set the subtitution values to the template keys.
    substitutions = [
      {"key"=>"-firstname-", "value"=>order.customer.first_name},
      {"key"=>"-orderNumber-", "value"=>order.request_id},
      {"key"=>"-total-", "value"=>subtotal},
      {"key"=>"-subtotal-", "value"=>subtotal},
      {"key"=>"-shippingFee-", "value"=>order.shipping_fee},
      {"key"=>"-fullName-", "value"=>order.customer.full_name},
      {"key"=>"-customerShippingAddress-", "value"=>order.shipping_address1 + ", " + order.shipping_address2},
      {"key"=>"-customerShippingCity-", "value"=>order.shipping_city},
      {"key"=>"-customerShippingState-", "value"=>order.shipping_state},
      {"key"=>"-customerShippingZipCode-", "value"=>order.shipping_zip_code},
      {"key"=>"-customerShippingCountryCode-", "value"=>order.shipping_country_code},
      {"key"=>"-customerMobile-", "value"=>order.mobile}
    ]
    
    response = SGMailer.new.send_mail(mail, recipients, substitutions)

    if (response.status_code.to_i).between?(200, 299)
      puts "Sent order confirmation email with Response Code: #{response.status_code}"
    else
      puts "Unable to send order confirmation email with Response Code: #{response.status_code}"
    end
  end
  
  def send_order_confirmation_email_for_admin(order, subtotal)
    mail             = SendGrid::Mail.new
    mail.from        = SendGrid::Email.new(email: 'info@vidanutriscience.com', name: 'Vida Nutriscience, Inc.')
    mail.subject     = 'Vida Nutriscience Order Confirmation'
    mail.template_id = '227037e8-fd9d-47ef-aedc-a95c8c8127ef'
    mail.add_category(SendGrid::Category.new(name: 'Order Confirmation'))
    mail.add_content(SendGrid::Content.new(type: 'text/html', value: order.get_html_order_details))

    # Set the recipients. You can specify recipient type to: 'to', 'cc' or 'bcc'.
    recipients = [
      {"email"=>"marketing@vidanutriscience.com", "name"=>"Vida Nutriscience", "type"=>"to"},
      {"email"=>"erika@digiteer.digital", "name"=>"Erika De Castro", "type"=>"to"}
    ]

    # Set the subtitution values to the template keys.
    substitutions = [
      {"key"=>"-firstname-", "value"=>order.customer.first_name},
      {"key"=>"-orderNumber-", "value"=>order.request_id},
      {"key"=>"-total-", "value"=>subtotal},
      {"key"=>"-subtotal-", "value"=>subtotal},
      {"key"=>"-shippingFee-", "value"=>order.shipping_fee},
      {"key"=>"-fullName-", "value"=>order.customer.full_name},
      {"key"=>"-customerShippingAddress-", "value"=>order.shipping_address1 + ", " + order.shipping_address2},
      {"key"=>"-customerShippingCity-", "value"=>order.shipping_city},
      {"key"=>"-customerShippingState-", "value"=>order.shipping_state},
      {"key"=>"-customerShippingZipCode-", "value"=>order.shipping_zip_code},
      {"key"=>"-customerShippingCountryCode-", "value"=>order.shipping_country_code},
      {"key"=>"-customerMobile-", "value"=>order.mobile}
    ]
    
    response = SGMailer.new.send_mail(mail, recipients, substitutions)

    if (response.status_code.to_i).between?(200, 299)
      puts "Sent order confirmation email with Response Code: #{response.status_code}"
    else
      puts "Unable to send order confirmation email with Response Code: #{response.status_code}"
    end
  end
end

class SGMailer
  # This handles the sending of the email.
  # Params:
  #   mail_object:   Mail object instance containing the initial basic settings.
  #   recipients:    JSON array containing the email, name and type of the recipients. The
  #                  recipient type can be either of the following: 'to', 'cc' or 'bcc'.
  #   substitutions: JSON array of all the substitution values from the keys in the template.
  #
  # Returns:
  #   response:      This is the responce code from SendGrid where we can analyze if the request
  #                  passed or not.
  def send_mail(mail_object, recipients, substitutions)
    @mail          = mail_object
    @recipients    = recipients
    @substitutions = substitutions

    set_personalizations if @recipients.present? && @substitutions.present?

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_VIDANUTRISCIENCE_API_KEY'], host: 'https://api.sendgrid.com')
    sg.client.mail._('send').post(request_body: @mail.to_json)
  end

  private
    # Set the needed personalizations.
    def set_personalizations
      @personalization = SendGrid::Personalization.new
      set_recipients
      set_substitutions
      @mail.add_personalization(@personalization)
    end

    # Set the personalization recipients.
    def set_recipients
      @recipients.each do |recipient|
        case recipient["type"]
          when 'to'
            @personalization.add_to(SendGrid::Email.new(email: recipient["email"], name: recipient["name"]))
          when 'cc'
            @personalization.add_cc(SendGrid::Email.new(email: recipient["email"], name: recipient["name"]))
          when 'bcc'
            @personalization.add_bcc(SendGrid::Email.new(email: recipient["email"], name: recipient["name"]))
        end
      end
    end

    # Set the personalization substitutions.
    def set_substitutions
      @substitutions.each do |substitution|
        @personalization.add_substitution(SendGrid::Substitution.new(key: substitution["key"], value: substitution["value"]))
      end
    end
end
