require 'open-uri'
# More document here https://getproxylist.com/

class ProxyGenerator
  FREE_PROXY_LIST_URL = 'https://www.free-proxy-list.net/'.freeze
  PROXY_SCRAPE_URL = 'https://api.proxyscrape.com/'.freeze
  PROXY_SCRAPE_OPTIONS = '?request=getproxies&proxytype=http&timeout=1000&country=all&ssl=all&anonymity=all'.freeze
  USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.131 Safari/537.36'.freeze

  def execute
    proxies! unless Proxy.any?

    proxy = Proxy.first
    url = proxy.url
    proxy.destroy
    'http://' + url
  end

  def proxies!
    request(PROXY_SCRAPE_URL + PROXY_SCRAPE_OPTIONS).split("\r\n").each do |row|
      Proxy.find_or_create_by(url: row) if valid_ipv4?(row.split(':')[0])
    end

    document = Nokogiri::HTML(request(FREE_PROXY_LIST_URL))
    document.css('tbody tr').each do |row|
      url = row.css('td')[0..1].map(&:text)
      Proxy.find_or_create_by(url: url.join(':')) if valid_ipv4?(url[0])
    end
  end

  def request(url)
    open(url, 'User-Agent' => USER_AGENT, &:read)
  end

  def valid_ipv4?(addr)
    if /\A(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})\Z/ =~ addr
      return $~.captures.all? {|i| i.to_i < 256}
    end
    false
  end
end
