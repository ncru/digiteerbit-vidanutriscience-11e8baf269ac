class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  protected
    def get_status
      case self.status
        when 0
          "Inactive"
        when 1
          "Active"
      end
    end

    def delete_photo
      self.photo = nil
    end
end
