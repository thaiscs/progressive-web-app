class SearchController < ApplicationController
  def index
    #todo: error handling for query and geocoder exception
    if params[:query].present?
      result = Geocoder.search(params[:query])
      @coordinates = result.first.coordinates
      @city = result.first.city
      byebug

      find_forecast
    else
    flash[:alert] = "City not found"
    end
  end

  def find_forecast
    base_url = "https://api.open-meteo.com/v1/forecast?"
    url = "#{base_url}latitude=#{@coordinates[0]}&longitude=#{@coordinates[1]}&current=temperature_2m"
    
    uri = URI(url)
    response = Net::HTTP.get(uri)
    json = JSON.parse(response)
    @forecast = json["current"]["temperature_2m"]

    # byebug
    render :show

  end
end