# Scraper https://batdongsan.com.vn to predict real estate price
require 'open-uri'
class Scrapers::Base
  include ActiveSupport::Rescuable
  PROHIBIT_CONTENT = 'sorry! something went wrong.'.freeze
  USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.131 Safari/537.36'.freeze
  BASE_URL = 'https://batdongsan.com.vn/'.freeze
  TIMEOUT_EXEPTIONS = [
    Errno::ETIMEDOUT,
    Net::OpenTimeout,
    SocketError,
    Net::ReadTimeout,
    Errno::ECONNRESET,
    RuntimeError,
    Net::HTTPServerException,
    StandardError,
    OpenSSL::SSL::SSLError,
    EOFError
  ].freeze

  rescue_from *TIMEOUT_EXEPTIONS do |e|
    slack_notifier.ping(e)
    nil
  end

  def initialize
    @proxy_url = ProxyGenerator.new.execute
    @retry_time = 0
  end

  def page_content(url)
    sleep((5..50).to_a.sample)
    requesting(url)
  rescue *TIMEOUT_EXEPTIONS => e
    @retry_time += 1
    if e.class.to_s != 'Errno::ETIMEDOUT' || @retry_time > 5
      @proxy_url = ProxyGenerator.new.execute
      slack_notifier.ping(e)
      @retry_time = 0
    end

    page_content(url)
  end

  def requesting(url)
    respone = Nokogiri::HTML(
      open(
        BASE_URL + url,
        'User-Agent' => USER_AGENT,
        proxy: @proxy_url,
        &:read
      )
    )
    raise 'Invalid content' if respone == PROHIBIT_CONTENT

    respone
  end

  def slack_notifier
    @slack_notifier ||= Slack::Notifier.new ENV['SLACK_HOOK_URL'] do
      defaults(channel: '#real_estate_bugs', username: 'notifier')
    end
  end
end
