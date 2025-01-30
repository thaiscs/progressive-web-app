class WeatherForecastApiFactory
  def self.create(api_type, latitude, longitude)
    case api_type
    when :open_meteo
      OpenMeteoApiService.new(latitude: latitude, longitude: longitude)
    # Add other services here
    else
      raise "Unknown service type: #{api_type}"
    end
  end
end
