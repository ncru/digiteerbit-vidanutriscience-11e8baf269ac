class DeviseCustomMailer < Devise::Mailer
  
  helper :application
  include Devise::Controllers::UrlHelpers
  require 'sendgrid/mailer'
  include SendGridMailer
  
  def reset_password_instructions(record, token, opts={})
    case record.class.name.downcase
      when 'customer'
        @resource_type = 'customer'
      when 'user'
        @resource_type = 'admin'
    end

    mail = SendGrid::Mail.new
    mail.from = SendGrid::Email.new(email: 'info@vidanutriscience.com', name: 'Vida Nutriscience, Inc.')
    mail.subject = 'Vida Nutriscience Password Reset Instruction'
    mail.add_category(SendGrid::Category.new(name: 'Password Reset'))
    mail.template_id = '80809add-91f9-4fcc-8c87-d86eaa9e1aca'
    mail.add_content(SendGrid::Content.new(type: 'text/html', value: '<div></div>'))

    # Set the recipients. You can specify recipient type to: 'to', 'cc' or 'bcc'.
    recipients = [
      {"email"=>record.email, "name"=>record.full_name, "type"=>"to"}
    ]

    # Set the subtitution values to the template keys.
    substitutions = [
      {"key"=>"-firstname-", "value"=>record.first_name},
      {"key"=>"-passwordResetLinkUrl-", "value"=>"https://vidanutriscience.herokuapp.com/#{@resource_type}/forgot/edit?reset_password_token=#{token}"}
    ]

    response = SGMailer.new.send_mail(mail, recipients, substitutions)

    if (response.status_code.to_i).between?(200, 299)
      puts "Sent password reset email with Response Code: #{response.status_code}"
    else
      puts "Unable to send password reset email with Response Code: #{response.status_code}"
    end
  end
end
