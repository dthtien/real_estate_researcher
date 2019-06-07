require 'open-uri'
# Scraper https://batdongsan.com.vn to predict real estate price
class Scrapers::RealEstate
  include ActiveSupport::Rescuable

  BASE_URL = 'https://batdongsan.com.vn/'.freeze
  HCM_REAL_ESTATE_URL = 'nha-dat-ban-tp-hcm'.freeze
  USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.131 Safari/537.36'.freeze
  BASE_ADDRESS_ELEMENT = '#RightMainContent__productCountByContext_bodyContainer #divCountByAreas ul a'.freeze
  REJECT_ADDRESS_TEXT = /(Khu vực: | Bán )/.freeze
  TIMEOUT_EXEPTION = [Errno::ETIMEDOUT, Net::OpenTimeout, SocketError].freeze

  rescue_from StandardError do |e|
    slack_notifier.ping(e)
    nil
  end

  def call
    scraping_urls.each do |url|
      url[:ward_links].each do |link|
        province = Province.find_or_create_by(
          name: url[:province],
          alias_name: VietnameseSanitizer.execute!(url[:province])
        )

        district = District.find_or_create_by(
          name: url[:distric_name],
          alias_name: VietnameseSanitizer.execute!(url[:distric_name]),
          parent_id: province.id
        )

        ward = Ward.find_or_create_by(
          name: link[:name],
          alias_name: VietnameseSanitizer.execute!(link[:name]),
          parent_id: district.id
        )

        page_count = total_page(page_content(link[:href]))
        ward.total_page = page_count
        ward.save!

        while page_count.positive?
          doc = page_content(link[:href] + "/p#{page_count}")
          next if doc.blank?
          land_list = doc.css('.product-list-page .search-productItem')
          land_list.each do |land|
            next if land.blank?

            save_land!(land_attributes(land), ward)
          end
          page_count -= 1
        end
      end
    end
  end

  alias scraping call

  private

  def parse_price(price, acreage)
    return [0, 0] if price.blank? || (price =~ /\d/).blank?

    amount_list = { 'tỷ' => 10**9, 'triệu' => 10**6, 'trăm' => 100**3 }
    amount, unit = price.split
    original_price = amount.to_f * amount_list[unit.gsub('/m²', '')]

    if price.include?('m²')
      [original_price, original_price * acreage.to_f]
    else
      [(original_price / acreage.to_f).round(2), original_price]
    end
  rescue TypeError => e
    slack_notifier.ping(e)
    nil
  end

  def slack_notifier
    @slack_notifier ||= Slack::Notifier.new ENV['SLACK_HOOK_URL'] do
      defaults(channel: '#real_estate_bugs', username: 'notifier')
    end
  end

  def scraping_urls
    @scraping_urls ||= list_urls(HCM_REAL_ESTATE_URL).map do |link|
                          puts link[:name]
                          {
                            distric_name: link[:name],
                            ward_links: list_urls(link[:href]),
                            href: link[:href],
                            province: 'Hồ Chí Minh'
                          }
                        end
  end

  def list_urls(url)
    page = page_content(url)
    page.css(BASE_ADDRESS_ELEMENT)
        .map { |a| { name: a.text.strip.downcase, href: a['href'] } }
  end

  def total_page(page)
    last_page = page.css('.background-pager-right-controls a').last
    last_page.present? ? last_page['href'].to_s.gsub(/[^\d]+/, '').to_i : 1
  end

  def page_content(url)
    Nokogiri::HTML(open(BASE_URL + url, 'User-Agent' => USER_AGENT, &:read))
  rescue *TIMEOUT_EXEPTION => e
    slack_notifier.ping(e)
    nil
  end

  def land_attributes(land_element)
    title_element = land_element.css('.p-title a')
    product_price = land_element.css('.product-price').text
    acreage = land_element.css('.product-area').text
    square_meter_price, total_price = parse_price(product_price, acreage)
    land_details = page_content(title_element.first[:href])
    return if land_details.blank?

    address_detail = land_details.css('.diadiem-title').text.strip
                                 .gsub(REJECT_ADDRESS_TEXT, '')
    {
      title: title_element.text.strip.downcase,
      acreage: acreage,
      address_detail: address_detail,
      square_meter_price: square_meter_price,
      total_price: total_price,
      desciption: land_details.css('.pm-desc').text.strip,
      post_date: land_element.css('.floatright.mar-right-10').text.strip
    }
  end

  def save_land!(attributes, ward)
    return if attributes.blank?

    ApplicationRecord.connection.transaction do
      street = Street.find_or_create_by(
        name: attributes[:address_detail],
        alias_name: VietnameseSanitizer.execute!(attributes[:address_detail]),
        parent_id: ward.id
      )

      land = Land.find_or_initialize_by(
        address_id: street.id,
        acreage: attributes[:acreage]
      )

      land.source_url = attributes[:source_url]
      land.title = attributes[:title]
      land.description = attributes[:desciption]
      square_meter_price = attributes[:square_meter_price]
      total_price = attributes[:total_price]

      land.post_date = attributes[:post_date]
      land.square_meter_price = square_meter_price
      land.total_price = total_price
      if land.persisted?
        if land.total_price_changed? || land.square_meter_price_changed?
          HistoryPrice.create(
            total_price: land.total_price_was || land.total_price,
            acreage: land.acreage,
            square_meter_price: land.square_meter_price_was || land.square_meter_prices,
            posted_date: land.post_date_was || land.post_date
          )
        end
      end

      land.save!
    end
  end
end
