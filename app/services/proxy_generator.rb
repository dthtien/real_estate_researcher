require 'open-uri'
# More document here https://getproxylist.com/

class ProxyGenerator
  PROXY_LIST_API = 'https://www.free-proxy-list.net/'.freeze
  USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.131 Safari/537.36'.freeze

  def execute
    proxies! unless Proxy.any?

    proxy = Proxy.first
    url = proxy.url
    proxy.destroy
    'http://' + url
  end

  def proxies!
    document = Nokogiri::HTML(open(PROXY_LIST_API, &:read))
    document.css('tbody tr').each do |row|
      url = row.css('td')[0..1].map(&:text).join(':')
      Proxy.find_or_create_by(url: url)
    end
  end
end
