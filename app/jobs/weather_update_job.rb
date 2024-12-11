class WeatherUpdateJob < ApplicationJob
  queue_as :default

  def perform
    Location.find_each do |location|
      # Your API logic to update the weather
      latitude, longitude = location.latitude, location.longitude
      base_url = "https://api.open-meteo.com/v1/forecast?"
      url = "#{base_url}latitude=#{latitude}&longitude=#{longitude}&current=temperature_2m"

      response = Net::HTTP.get(URI(url))
      data = JSON.parse(response)

      if data["current"]
        location.update(current_temperature: data["current"]["temperature_2m"])
      else
        Rails.logger.error("Weather API response invalid for location #{location.id}")
      end
    end
  end
end
