class Search::ForecastsController < ApplicationController
  before_action :identify_user

  def index
    @locations = @current_user.locations.order(created_at: :desc)

    #todo: error handling for query and geocoder exception
    if params[:query].present?
      search_result = Geocoder.search(params[:query])
      @coordinates = search_result.first.coordinates
      @location_name = search_result.first.data["name"]
      @location_country = search_result.first.data["address"]["country"]

      redirect_to search_forecasts_location_url(
        latitude: @coordinates[0], 
        longitude: @coordinates[1],
        name: @location_name,
        country: @location_country
        )
      save_searched_location
    else
    flash[:alert] = "Location not found"
    end
  end

  def show_weather_forecast
    latitude = params[:latitude]
    longitude = params[:longitude]
    @location_name = params[:name]
    @location_country = params[:country]

    base_url = "https://api.open-meteo.com/v1/forecast?"
    url = "#{base_url}latitude=#{latitude}&longitude=#{longitude}&current=temperature_2m"
    
    uri = URI(url)
    request = Net::HTTP.get(uri)
    response = JSON.parse(request)
    @current_temperature = response["current"]["temperature_2m"]
 
    render :show
  end

  private

  def save_searched_location
    location = @locations.find_by(name: @location_name)
  
    if location
      location.update(current_temperature: @current_temperature)
      return
    end
    # Ensure the locations list is limited to 5 most recent
    @locations.last.destroy if @locations.count >= 5
    
    searched_location = @locations.new(
      name: @location_name,
      country: @location_country,
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