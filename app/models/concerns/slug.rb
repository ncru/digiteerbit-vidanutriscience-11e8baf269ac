module Slug
  extend ActiveSupport::Concern

  included do
    after_create :generate_slug
    before_save  :update_slug
  end

  private
    def generate_slug
      if self.slug.blank? && self.name.present?
        self.slug = self.id.to_s+"-"+self.name.parameterize
        self.save
      end
    end

    def update_slug
      if self.name.present? && self.name_changed? && !self.new_record?
        self.slug = self.id.to_s+"-"+self.name.parameterize
      end
    end
end
