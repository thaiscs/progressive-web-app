class WeatherApiServiceFactory
  def self.create(service_type, latitude, longitude)
    case service_type
    when :open_meteo
      WeatherApiService.new(latitude: latitude, longitude: longitude)
    # Add other services here
    else
      raise "Unknown service type: #{service_type}"
    end
  end
end
