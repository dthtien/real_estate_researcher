module Facebook
  class User < Base
    def page_token
      params = "fields=access_token&access_token=#{ENV['FB_PAGE_TOKEN']}"
      request_url = "#{FB_GRAPH_API_URL}/#{ENV['FB_PAGE_ID']}?#{params}"
      http_client.get(request_url)
    end
  end
end
