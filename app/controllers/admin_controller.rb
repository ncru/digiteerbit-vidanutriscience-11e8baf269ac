class AdminController < ApplicationController
  layout 'admin'

  include Datatable

  before_action :check_and_authenticate_user
  before_action :authenticate_user!

  protected
    # Initialize resources for uploading files/images to S3 bucket.
    def set_cors
      @s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/#{SecureRandom.uuid}/${filename}", success_action_status: 201, acl: :public_read, cache_control: "public, max-age=31557600", expires_header: DateTime.now.advance(years: 1).httpdate)
      @photos = Photo.order("id DESC").limit(18)
      @photo = Photo.new
    end

    # Creates an entry in the audittrails table.
    def log_to_audittrail(action, moduletype, modulename)
      @audittrail = Audittrail.new
      @audittrail.module = moduletype
      @audittrail.ip_address = current_user.current_sign_in_ip
      @audittrail.modified_by_email = current_user.email
      @audittrail.modified_by_name = current_user.full_name

      case action
        when 'add'
          @audittrail.event_description = 'Created new ' + moduletype + ' - ' + modulename + '.'
        when 'edit'
          @audittrail.event_description = 'Updated ' + moduletype + ' - ' + modulename + '.'
        when 'delete'
          @audittrail.event_description = 'Deleted ' + moduletype + ' - ' + modulename + '.'
      end

      if @audittrail.save
        puts "Successfully added an entry in Audit Trail."
      end
    end
    
    # Removes empty values in an array.
    def sanitize_array(array)
      array.reject!(&:blank?)
    end

  private
    def check_and_authenticate_user
      redirect_to new_user_session_path unless user_signed_in?
    end
end
