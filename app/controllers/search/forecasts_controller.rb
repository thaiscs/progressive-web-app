class Search::ForecastsController < ApplicationController
  before_action :identify_user

  def index
    #todo: location per user
    @locations = Location.all

    #todo: error handling for query and geocoder exception
    if params[:query].present?
      search_result = Geocoder.search(params[:query])
      @coordinates = search_result.first.coordinates
      @location = search_result.first.data["name"]
      # byebug

      save_searched_location
      show_weather_forecast
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
    @forecast = response["current"]["temperature_2m"]

    # byebug
    render :show
  end

  def save_searched_location
    # byebug
    searched_location = @current_user.locations.new(
      name: params[:query],
      latitude: @coordinates[0],
      longitude: @coordinates[1]
    )

    # Save only the last 5 locations
    if @current_user.locations.count >= 5
      # Remove the oldest location if there are already 5
      @current_user.locations.order(:created_at).first.destroy
    end

    if searched_location.save
      # json: { message: "Location saved successfully" }, status: :ok
    else
      flash[:alert] = searched_location.errors
    end
  end
end