class Facebook::Page
  attr_reader :http_client
  FB_GRAPH_API_URL='https://graph.facebook.com'.freeze

  def initialize
    @http_client = HTTParty
  end

  def post!(content)
    request_url = "#{FB_GRAPH_API_URL}/#{ENV['FB_PAGE_ID']}/feed"
    http_client.post(
      request_url,
      body: {
        access_token: ENV['FB_PAGE_TOKEN'],
        message: content
      }
    )
  end

  def delete_post!(post_id)
    request_url = "#{FB_GRAPH_API_URL}/#{post_id}"
    http_client.delete(
      request_url,
      body: { access_token: ENV['FB_PAGE_TOKEN'] }
    )
  end
end
