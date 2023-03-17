module Admin
  class PhotosController < AdminController

    # GET /admin/photos
    def index
      set_cors
    end

    # POST /admin/photos
    def create
      photo = Photo.new(photo_params)

      respond_to do |format|
        if photo.save
          format.js { render :action => "success" }
        else
          format.js { render :action => "error" }
        end
      end
    end

    # DELETE /admin/photos/:id
    def destroy
      @photo = Photo.find(params[:id])
      @photo.destroy

      respond_to do |format|
        flash[:notice] = "The photo with URL <strong>" + @photo.photo_url + "</strong> has been successfully removed."
        log_to_audittrail('delete', 'PHOTO', @photo.photo_url)

        flash.discard if Photo.all.count(1) == 0

        format.html { redirect_to admin_photos_path }
      end
    end

    # Load more photos from the server.
    def load_more_photos
      offset_count = params[:page].to_i*18
      @photos = Photo.offset(offset_count).limit(18).order("id DESC")

      respond_to do |format|
        format.js { render :action => "load_more_photos" }
      end
    end

    # This just basically reload the list of photos.
    def refresh_photos_list
      @photo = Photo.new
      @photos = Photo.order("id DESC")

      respond_to do |format|
        format.js { render :action => "refresh_photos_list" }
      end
    end

    private
      def photo_params
        params.require(:photo).permit(:photo_url)
      end
  end
end
