class WeatherForecastService
  def initialize(latitude, longitude, api_service:)
    @api_service = api_service
  end

  def get_current_temperature
    data = @api_service.fetch_weather_data("current=temperature_2m")
    extract_value(data, ["current", "temperature_2m"])
  end
  # Additional methods for other weather data as needed

  private

  def extract_value(data, keys)
    keys.reduce(data) { |memo, key| memo[key] } if data.is_a?(Hash)
  end
end
