require 'open-uri'

class Scrapers::RealEstate
  BASE_URL = 'https://batdongsan.com.vn/'.freeze
  HCM_REAL_ESTATE_URL = 'nha-dat-ban-tp-hcm'.freeze
  USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.131 Safari/537.36'.freeze
  BASE_ADDRESS_ELEMENT = '#RightMainContent__productCountByContext_bodyContainer #divCountByAreas ul a'.freeze
  REJECT_ADDRESS_TEXT = 'Khu vực: '.freeze

  def call
    scraping_urls.each do |url|
      url[:ward_links].each do |link|
        ApplicationRecord.connection.transaction do
          address = Address.find_or_create_by(
            ward: link[:name],
            district: url[:distric_name],
            province: url[:province]
          )

          page_count = 1 #total_page(page_content(link[:href]))
          address.total_page = page_count
          address.save!
          while page_count.positive?
            doc = page_content(link[:href] + "/p#{page_count}")
            land_list = doc.css('.product-list-page .search-productItem')
            land_list.each { |land| save_land!(land_attributes(land), address) }
            page_count -= 1
          end
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
  end

  def slack_notifier
    @slack_notifier ||= Slack::Notifier.new ENV['SLACK_HOOK_URL'] do
      defaults(channel: '#real_estate_bugs', username: 'notifier')
    end
  end

  def scraping_urls
    @scraping_urls ||= list_urls(HCM_REAL_ESTATE_URL)[0..0].map do |link|
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
        .map { |a| { name: a.text.strip, href: a['href'] } }
  end

  def total_page(page)
    last_page = page.css('.background-pager-right-controls a').last
    last_page.present? ? last_page['href'].to_s.gsub(/[^\d]+/, '').to_i : 1
  end

  def page_content(url)
    Nokogiri::HTML(open(BASE_URL + url, 'User-Agent' => USER_AGENT, &:read))
  end

  def land_attributes(land_element)
    title_element = land_element.css('.p-title a')
    product_price = land_element.css('.product-price').text
    acreage = land_element.css('.product-area').text
    square_meter_price, total_price = parse_price(product_price, acreage)
    land_details = page_content(title_element.first[:href])
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

  def save_land!(attributes, address)
    land = Land.find_or_initialize_by(
      address_id: address.id,
      acreage: attributes[:acreage],
      address_detail: attributes[:address_detail]
    )

    land.source_url = attributes[:source_url]
    land.title = attributes[:title]
    land.description = attributes[:desciption]
    square_meter_price = attributes[:square_meter_price]
    total_price = attributes[:total_price]
    is_price_change = land.square_meter_price.present? &&
                        land.square_meter_price != square_meter_price

    if is_price_change
      HistoryPrice.create(
        total_price: land.total_price,
        acreage: land.acreage,
        square_meter_price: land.square_meter_price,
        posted_date: land.post_date
      )

      land.post_date = attributes[:post_date]
      land.total_price = total_price
      land.square_meter_price = square_meter_price
      land.save!
      return
    end

    land.square_meter_price = square_meter_price
    land.total_price = total_price
    land.save!
  end
end
