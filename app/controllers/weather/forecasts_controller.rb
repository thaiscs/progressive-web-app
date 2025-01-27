class Weather::ForecastsController < ApplicationController
  before_action :identify_user

  def index
    @locations = @current_user.locations.order(created_at: :desc)
    search_location if params[:query].present?
  end

  def show
    #todo: update backend with current_temperature? check update Job
    location_data = location_params.merge(
      current_temperature: forecast_service.get_current_temperature
    ).to_h
    render :show, locals: { location_data: location_data }
    save_location(location_data) #todo: refactor because in every show (even when not new location) is calling save_recent_locations
  end

  private
  def search_location
    @location_info = GeocodeService.search(params[:query]) #todo: error handling geocoder exception
    redirect_to weather_forecasts_location_url(location_data)
  end

  def save_location(location_data)   
    Location.save_recent_locations(@current_user, location_data)
  end

  def forecast_service
    api_service = params[:service_type]&.to_sym || :open_meteo
    service_factory = WeatherApiServiceFactory.new(api_service, params[:latitude], params[:longitude])
    service_factory.create
  end

  def location_data 
    #todo: check memoization in chatgpt
    #todo: create obj model or Struct to instantiate it globally?
    {
      name: @location_info[:name],
      country: @location_info[:country],
      latitude: @location_info[:coordinates][0],
      longitude: @location_info[:coordinates][1],
    }
  end

    def location_params
      params.permit(:name, :country, :latitude, :longitude, :current_temperature)
    end  
end