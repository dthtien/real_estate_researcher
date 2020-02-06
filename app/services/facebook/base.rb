class Facebook::Base
  attr_reader :http_client
  FB_GRAPH_API_URL = 'https://graph.facebook.com'.freeze

  def initialize
    @http_client = HTTParty
  end
end
