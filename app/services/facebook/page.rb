module Facebook
  class Page < Base
    FB_API_URL = "#{FB_GRAPH_API_URL}/#{ENV['FB_PAGE_ID']}".freeze

    def post!(content, options = {})
      request_url = "#{FB_API_URL}/feed"
      http_client.post(
        request_url,
        body: {
          access_token: ENV['FB_PAGE_TOKEN'],
          message: content
        }.merge(options)
      )
    end

    def upload_images!(images)
      images.map do |image|
        upload_image!(image['origin'])
      end
    end

    def upload_image!(image, published: false)
      request_url = "#{FB_API_URL}/photos"
      reponse = http_client.post(
        request_url,
        body: {
          access_token: ENV['FB_PAGE_TOKEN'],
          url: image,
          published: published
        }
      )

      reponse.parsed_response['id']
    end

    def delete_post!(post_id)
      request_url = "#{FB_GRAPH_API_URL}/#{post_id}"
      http_client.delete(
        request_url,
        body: { access_token: page_token }
      )
    end

    private

    def page_token
      @page_token ||= Facebook::User.new.page_token['access_token']
    end
  end
end
