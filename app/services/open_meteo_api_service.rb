class OpenMeteoApiService
  BASE_URL = "https://api.open-meteo.com/v1/forecast" 
  #todo: move to env variable: BASE_URL = ENV.fetch('WEATHER_API_BASE_URL', "https://api.open-meteo.com/v1/forecast")
  
  def initialize(latitude:, longitude:, request_builder: WeatherForecastRequestBuilder.new)
    @latitude = latitude
    @longitude = longitude
    @request_builder = request_builder
  end

  def get_current_temperature
    response = @request_builder
                .set_base_url(BASE_URL)
                .add_query_param("latitude", @latitude)
                .add_query_param("longitude", @longitude)
                .add_query_param("current", "temperature_2m")
                .fetch

    extract_value(response, ["current", "temperature_2m"])
  end

  private

  def extract_value(response, params)
    params.reduce(response) { |json, key| json[key] } if response.is_a?(Hash)
  end
end
