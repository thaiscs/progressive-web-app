class WeatherApiServiceFactory

  def initialize(api_service, latitude, longitude)    
    @api_service = api_service
    @latitude = latitude
    @longitude = longitude
  end

  def create
    WeatherForecastServiceBuilder.create(@api_service, @latitude, @longitude)
  end
end
