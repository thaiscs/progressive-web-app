class GeocodeService
  def self.search(query)
    result = Geocoder.search(query)
    {
      coordinates: result.first.coordinates,
      name: result.first.data["name"],
      country: result.first.data["address"]["country"]
    }
  end
end