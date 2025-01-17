class Location < ApplicationRecord
  belongs_to :user
  MAX_LOCATIONS = 5

  def self.save_recent_locations(user, location_data, limit = MAX_LOCATIONS)
    locations = user.locations
    location = find_or_initialize_per_user(locations, location_data)

    if location.persisted?
      location.update(current_temperature: location_data[:current_temperature])
      return
    end
    if location.save
      enforce_location_limit(locations, limit)
    end
  end

  private

  def self.find_or_initialize_per_user(locations, location_data)
    locations.find_or_initialize_by(name: location_data[:name]) do |loc|
      loc.country = location_data[:country]
      loc.latitude = location_data[:latitude]
      loc.longitude = location_data[:longitude]
      loc.current_temperature = location_data[:current_temperature]
    end
  end

  def self.enforce_location_limit(locations, limit)
    locations.order(created_at: :desc).last.destroy if locations.count >= limit
  end
end
