require 'open-uri'
# More document here https://getproxylist.com/

module ProxyGenerator
  PROXY_LIST_API = 'https://api.getproxylist.com/proxy'.freeze
  OPTIONS = '?protocol[]=http&protocol[]=https'.freeze

  def self.execute
    response = JSON.parse open(PROXY_LIST_API + OPTIONS, &:read)

    "#{response['protocol']}://#{response['ip']}:#{response['port']}"
  end
end
