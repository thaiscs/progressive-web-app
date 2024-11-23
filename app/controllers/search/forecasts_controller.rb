class Search::ForecastsController < ApplicationController
  before_action :identify_user

  def index
    @locations = @current_user.locations

    #todo: error handling for query and geocoder exception
    if params[:query].present?
      search_result = Geocoder.search(params[:query])
      @coordinates = search_result.first.coordinates
      @location_name = search_result.first.data["name"]

      show_weather_forecast
      save_searched_location
    else
    flash[:alert] = "Location not found"
    end
  end

  private
  def show_weather_forecast
    base_url = "https://api.open-meteo.com/v1/forecast?"
    url = "#{base_url}latitude=#{@coordinates[0]}&longitude=#{@coordinates[1]}&current=temperature_2m"
    
    uri = URI(url)
    request = Net::HTTP.get(uri)
    response = JSON.parse(request)
    @current_temperature = response["current"]["temperature_2m"]

    render :show
  end

  def save_searched_location
    location = @locations.find_by(name: @location_name)
  
    if location
      location.update(current_temperature: @current_temperature)
      return
    end
    # Ensure the locations list is limited to 5 most recent
    @locations.order(:created_at).first.destroy if @locations.count >= 5
    
    searched_location = @locations.new(
      name: params[:query],
      latitude: @coordinates[0],
      longitude: @coordinates[1],
      current_temperature: @current_temperature
    )
  
    if searched_location.save
      # json: { message: "Location saved successfully" }, status: :ok
    else
      flash[:alert] = searched_location.errors.full_messages
    end
  end
end