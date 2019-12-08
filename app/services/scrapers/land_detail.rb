class Scrapers::LandDetail < Scrapers::Base
  REJECT_ADDRESS_TEXT = /(khu vực: |bán)/.freeze
  BILLION = 10**9
  MILLION = 10**6
  THOUSANT = 10**3

  def call
    slack_notifier.ping('Start scrapping!')

    Ward.not_finish.find_each do |ward|
      update_ward!(ward)
    end
  end

  def call_with_district(district)
    slack_notifier.ping('Start scrapping!')

    district.wards.not_finish.each do |ward|
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

    GC.start
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
    land.attributes = attributes.except(:acreage)

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
    expired_date = land_details.css('.prd-more-info div:last-child')
                               .children.last.text.strip
    title = title_element.text.strip.downcase

    {
      title: title,
      alias_title: VietnameseSanitizer.execute!(title),
      acreage: acreage,
      address_detail: address_detail,
      square_meter_price: square_meter_price,
      total_price: total_price,
      description: land_details.css('.pm-desc').text.strip,
      post_date: land_element.css('.uptime').text.strip,
      expired_date: expired_date
    }
  end

  def parse_price(price, acreage)
    return [0, 0] if price.blank? || (price =~ /\d/).blank?

    amount_list = { 'tỷ' => BILLION, 'triệu' => MILLION, 'trăm' => THOUSANT }
    amount, unit = price.split
    original_price = amount.to_f * amount_list[unit.gsub('/m²', '')]

    correct_price(acreage, original_price, price)
  rescue TypeError => e
    slack_notifier.ping(e)
    nil
  end

  def correct_price(acreage, original_price, price)
    if price.include?('m²')
      square_meter_price = original_price
      total_price = original_price * acreage.to_f
    else
      square_meter_price = (original_price / acreage.to_f).round(2)
      total_price = original_price
    end

    parse_number(square_meter_price, total_price)
  end

  def parse_number(square_meter_price, total_price)
    if square_meter_price > BILLION
      square_meter_price /= THOUSANT
      total_price /= THOUSANT
    end

    if total_price.positive? && total_price < 10**8
      increase_rate = 10 - total_price.to_i.to_s.size
      total_price *= 10**increase_rate
      square_meter_price *= 10**increase_rate
    end

    [square_meter_price, total_price]
  end
end
