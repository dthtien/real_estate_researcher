class Scrapers::LandDetail < Scrapers::Base
  REJECT_ADDRESS_TEXT = /(khu vực: |bán)/.freeze

  def call
    slack_notifier.ping('Start scrapping!')

    Ward.where(finish: false).find_each do |ward|
      update_ward!(ward)
    end
  end

  def call_with_district(district)
    slack_notifier.ping('Start scrapping!')

    district.wards.where(finish: false).find_each do |ward|
      update_ward! ward
    end
  end

  def update_ward!(ward)
    page_count = ward.total_page - ward.scrapping_page

    p ward.name
    while page_count.positive?
      p page_count
      processing_land(ward, page_count)
      page_count -= 1
      ward.update_attribute(:scrapping_page, ward.scrapping_page + 1)
    end
    ward.update_attribute(:finish, true)
  end

  private

  def processing_land(ward, page_count)
    doc = page_content(ward.scrapping_link.freeze + "/p#{page_count}")
    return if doc.blank?

    land_list = doc.css('.product-list-page .search-productItem')
    land_list.each do |land|
      next if land.blank?

      save_land!(land_attributes(land), ward)
    end
  end

  def save_land!(attributes, ward)
    return if attributes.blank?

    ApplicationRecord.connection.transaction do
      street = Street.find_or_create_by(
        name: attributes[:address_detail],
        alias_name: VietnameseSanitizer.execute!(attributes[:address_detail]),
        parent_id: ward.id
      )
      land = assign_land_detail(attributes, street)
      save_history!(land) if information_changed?(land)
      land.save!
    end
  end

  def assign_land_detail(attributes, street)
    land = Land.find_or_initialize_by(
      street: street,
      acreage: attributes[:acreage]
    )
    land.source_url = attributes[:source_url]
    land.title = attributes[:title]
    land.alias_title = VietnameseSanitizer.execute!(attributes[:title])
    land.description = attributes[:desciption]
    land.post_date = attributes[:post_date]
    land.square_meter_price = attributes[:square_meter_price]
    land.total_price = attributes[:total_price]

    land
  end

  def information_changed?(land)
    land.persisted? && (
      land.total_price_changed? || land.square_meter_price_changed?)
  end

  def save_history!(land)
    square_meter_price = land.square_meter_price_was || land.square_meter_price

    HistoryPrice.create(
      total_price: land.total_price_was || land.total_price,
      acreage: land.acreage,
      square_meter_price: square_meter_price,
      posted_date: land.post_date_was || land.post_date,
      land: land
    )
  end

  def land_attributes(land_element)
    title_element = land_element.css('.p-title a')
    product_price = land_element.css('.product-price').text
    acreage = land_element.css('.product-area').text
    square_meter_price, total_price = parse_price(product_price, acreage)
    land_details = page_content(title_element.first[:href])
    return if land_details.blank?

    address_detail = land_details.css('.diadiem-title').text.strip
                                .downcase
                                .gsub(REJECT_ADDRESS_TEXT, '')
    {
      title: title_element.text.strip.downcase,
      acreage: acreage,
      address_detail: address_detail,
      square_meter_price: square_meter_price,
      total_price: total_price,
      desciption: land_details.css('.pm-desc').text.strip,
      post_date: land_element.css('.uptime').text.strip
    }
  end

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
end
