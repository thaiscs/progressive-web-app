class OpenMeteoApiService
  BASE_URL = "https://api.open-meteo.com/v1/forecast" 
  #todo: move to env variable: BASE_URL = ENV.fetch('WEATHER_API_BASE_URL', "https://api.open-meteo.com/v1/forecast")
  
  def initialize(latitude:, longitude:)
    @latitude = latitude
    @longitude = longitude
    @api_service = WeatherForecastService.new
  end

  def get_current_temperature
    url = build_url("current=temperature_2m")
    response = @api_service.fetch_weather_forecast(url)
    extract_value(response, ["current", "temperature_2m"])
  end
  # Additional methods for other weather data as needed

  private

  def build_url(query_params)
    "#{BASE_URL}?latitude=#{@latitude}&longitude=#{@longitude}&#{query_params}"
  end

  def extract_value(response, params)
    params.reduce(response) { |json, key| json[key] } if response.is_a?(Hash)
  end
end
