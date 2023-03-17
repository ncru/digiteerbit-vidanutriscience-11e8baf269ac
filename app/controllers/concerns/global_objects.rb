module GlobalObjects
  extend ActiveSupport::Concern

  included do
    before_action :initialize_global_objects
  end

  private
    def initialize_global_objects
    end
end
