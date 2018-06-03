class LocationsController < ApplicationController

  def show
    @locations = Location.locations_for_country(params[:country_code])
    render json: @locations.as_json(only: fields)
  end
  
  private
  
  def fields
    if authenticated?
      %i[id name external_id secret_code]
    else
      %i[id name external_id]
    end
  end

end
