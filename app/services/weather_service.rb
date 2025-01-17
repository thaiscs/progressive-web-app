class WeatherService
  def self.get_current_temperature(latitude, longitude)
    base_url = "https://api.open-meteo.com/v1/forecast?"
    url = "#{base_url}latitude=#{latitude}&longitude=#{longitude}&current=temperature_2m"
    uri = URI(url)
    request = Net::HTTP.get(uri)
    return response = JSON.parse(request)["current"]["temperature_2m"] #todo: error handling
  end
end