class WeatherForecastService

  def fetch_weather_forecast(url)
    response = make_request(url)
    parse_response(response)
  end
  
  private

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