module Site
  class CitiesController < SiteController
    def retrieve_cities
      cities = City.where(province_id: params[:province_id])
      
      # Return the cities.
      respond_to do |format|
        format.json  { 
          render json: { cities: cities }
        }
      end
    end
  end
end
