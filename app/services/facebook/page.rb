module Facebook
  class Page < Base

    def post!(content, options = {})
      request_url = "#{FB_GRAPH_API_URL}/#{ENV['FB_PAGE_ID']}/feed"
      http_client.post(
        request_url,
        body: {
          access_token: ENV['FB_PAGE_TOKEN'],
          message: content
        }.merge(options)
      )
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
