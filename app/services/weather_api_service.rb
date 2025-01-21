class WeatherApiService
  BASE_URL = "https://api.open-meteo.com/v1/forecast" 
  #todo: move to env variable: BASE_URL = ENV.fetch('WEATHER_API_BASE_URL', "https://api.open-meteo.com/v1/forecast")

  def initialize(latitude:, longitude:)
    @latitude = latitude
    @longitude = longitude
  end

  def fetch_weather_data(query_params)
    url = build_url(query_params)
    response = make_request(url)
    parse_response(response)
  end

  private
  def build_url(query_params)
    "#{BASE_URL}?latitude=#{@latitude}&longitude=#{@longitude}&#{query_params}"
  end

  def make_request(url)
    uri = URI(url)
    Net::HTTP.get(uri)
  rescue StandardError => e
    # Handle errors like connection issues, timeouts, etc.
    { error: "Failed to fetch data: #{e.message}" }.to_json
  end

  def parse_response(response)
    JSON.parse(response)
  rescue JSON::ParserError => e
    { error: "Failed to parse response: #{e.message}" }
  end
end