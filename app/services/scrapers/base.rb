# Scraper https://batdongsan.com.vn to predict real estate price
require 'open-uri'
class Scrapers::Base
  include ActiveSupport::Rescuable

  USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.131 Safari/537.36'.freeze
  BASE_URL = 'https://batdongsan.com.vn/'.freeze
  TIMEOUT_EXEPTION = [Errno::ETIMEDOUT, Net::OpenTimeout, SocketError].freeze

  rescue_from StandardError do |e|
    slack_notifier.ping(e)
    nil
  end

  protected

  def page_content(url)
    sleep((0..3).to_a.sample)
    Nokogiri::HTML(open(BASE_URL + url, 'User-Agent' => USER_AGENT, &:read))
  rescue *TIMEOUT_EXEPTION => e
    slack_notifier.ping(e)
    nil
  end

  def slack_notifier
    @slack_notifier ||= Slack::Notifier.new ENV['SLACK_HOOK_URL'] do
      defaults(channel: '#real_estate_bugs', username: 'notifier')
    end
  end
end
