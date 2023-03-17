module Admin
  class ProfileController < AdminController

    # GET /admin/profile
    def index
      @user = User.find(current_user.id)
    end
  end
end
