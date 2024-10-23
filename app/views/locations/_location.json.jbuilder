json.extract! location, :id, :name, :country, :latitude, :longitude, :created_at, :updated_at
json.url location_url(location, format: :json)
