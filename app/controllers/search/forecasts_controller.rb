class Search::ForecastsController < ApplicationController
  before_action :identify_user

  def index
    @locations = @current_user.locations.order(created_at: :desc)
    search_and_save_location if params[:query].present?
  end

  def show
    current_temperature = WeatherService.get_current_temperature(params[:latitude], params[:longitude])
    #todo: update backend with current_temperature? check update Job
    render :show, locals: { 
      location_data: location_params.merge(current_temperature: current_temperature).to_h 
    }
  end

  private
  def search_and_save_location   
    @location_info = GeocodeService.search(params[:query]) #todo: error handling geocoder exception
    @current_temperature = WeatherService.get_current_temperature(location_data[:latitude], location_data[:longitude])

    redirect_to search_forecasts_location_url(location_data)
    Location.save_recent_locations(@current_user, location_data)
  end

  def location_data
    {
      name: @location_info[:name],
      country: @location_info[:country],
      latitude: @location_info[:coordinates] ? @location_info[:coordinates][0] : nil,
      longitude: @location_info[:coordinates] ? @location_info[:coordinates][1] : nil,
      current_temperature: @current_temperature
    }
  end

    def location_params
      params.permit(:name, :country, :current_temperature)
    end  
end