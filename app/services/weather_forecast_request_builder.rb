class WeatherForecastRequestBuilder
  def initialize
    @base_url = nil
    @query_params = {}
  end

  def set_base_url(base_url)
    @base_url = base_url
    self
  end

  def add_query_param(key, value)
    @query_params[key] = value
    self
  end

  def fetch
    raise "Base URL is not set" unless @base_url

    url = build_url
    response = make_request(url)
    parse_response(response)
  end

  private

  def build_url
    uri = URI(@base_url)
    uri.query = URI.encode_www_form(@query_params)
    uri.to_s
  end

  def make_request(url)
    uri = URI(url)
    Net::HTTP.get(uri)
  rescue StandardError => e
    { error: "Failed to fetch data: #{e.message}" }.to_json
  end

  def parse_response(response)
    JSON.parse(response)
  rescue JSON::ParserError => e
    { error: "Failed to parse response: #{e.message}" }
  end
end
