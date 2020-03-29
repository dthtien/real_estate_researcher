module Scrapers::BdsScrappers
  class LandDetail < Scrapers::BdsScrappers::Base
    REJECT_ADDRESS_TEXT = /(khu vực: |bán)/.freeze
    BILLION = 10**9
    MILLION = 10**6
    THOUSANT = 10**3
    LARGE_IMAGE_SIZE = '745x510'.freeze
    THUMB_IMAGE_SIZE = '200x200'.freeze
    LAND_CLASSIFICATION_KEYS = [
      'Bán căn hộ chung cư', 'Bán nhà riêng', 'Bán nhà biệt thự, liền kề',
      'Bán nhà mặt phố', 'Bán đất nền dự án', 'Bán đất',
      'Bán trang trại, khu nghỉ dưỡng', 'Bán kho, nhà xưởng',
      'Bán loại bất động sản khác'
    ].freeze

    def call
      slack_notifier.ping('Start scrapping!')

      Ward.not_finish.each do |ward|
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

      save_lands!(doc, ward)

      GC.start
    rescue ActiveRecord::RecordNotUnique => e
      slack_notifier.ping(e)
    end

    def save_lands!(doc, ward)
      land_list = doc.css('.product-list-page .search-productItem')

      land_list.each do |land|
        next if land.blank?

        attributes = land_attributes(land)
        save_land!(attributes, ward) if attributes.present?
      end
    end

    def save_land!(attributes, ward)
      street = Street.find_or_create_by(
        name: attributes[:address_detail],
        alias_name: VietnameseSanitizer.execute!(attributes[:address_detail]),
        parent_id: ward.id
      )
      land = assign_land_detail(attributes, street, ward)

      Land.transaction do
        user = set_user!(attributes[:user], land)
        land.user_id = user.id if user.present?
        save_history!(land) if information_changed?(land)
        land.save!
      end
    end

    def set_user!(user_attributes, land)
      return if user_attributes[:phone_number].blank?

      user = User.find_or_initialize_by(
        phone_number: user_attributes[:phone_number]
      )
      user.attributes = user_attributes.except(:phone_number)
      if land.new_record? || land.user_id.blank?
        user.selling_times = user.selling_times + 1
      end
      user.agency = user.selling_times > 2
      user.save!

      user
    end

    def assign_land_detail(attributes, street, ward)
      land = Land.find_or_initialize_by(
        street: street,
        acreage: attributes[:acreage]
      )
      land.attributes = attributes.except(:acreage, :user)
      land.ward_id = ward.id
      land.district_id = ward.district.id
      land.province_id = ward.district.province.id

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
      product_price = land_element.css('.product-price')&.text
      acreage = land_element.css('.product-area')&.text
      square_meter_price, total_price = parse_price(product_price, acreage)
      source_url = title_element.first[:href]
      land_details = page_content(source_url)

      return if land_details.blank?

      address_detail = land_details.css('.diadiem-title'.freeze)&.text&.strip
                                  &.downcase
                                  .gsub(REJECT_ADDRESS_TEXT, '')
      expired_date = land_details.css('.prd-more-info div:last-child'.freeze)
                                .children.last&.text&.strip
      title = title_element&.text&.strip&.downcase
      front_length = land_details.css(
        '#LeftMainContent__productDetail_frontEnd div.right'.freeze
      ).text&.strip
      classification = land_details.css(
        '#product-other-detail div.row:first-child div.right'.freeze
      ).text&.strip
      classification = classification.split(' (').first if classification.present?
      phone_number = land_details.css(
        '#LeftMainContent__productDetail_contactMobile .contact-phone'
      ).text.strip
      username = land_details.css(
        '#LeftMainContent__productDetail_contactName .right'
      ).text
      email = land_details.css('#contactEmail .contact-email').text

      if email.present?
        email = email[%r{\<a.+\/a\>}]
        email = Nokogiri::HTML.parse(email).text
      end

      images = land_details.css('.list-img img')

      if images.present?
        images = images.map do |image|
          src = image.attr('src')
          {
            thumb: src,
            origin: src.gsub(THUMB_IMAGE_SIZE, LARGE_IMAGE_SIZE)
          }
        end
      end

      {
        title: title,
        alias_title: VietnameseSanitizer.execute!(title),
        acreage: acreage,
        address_detail: address_detail,
        square_meter_price: square_meter_price,
        total_price: total_price,
        description: land_details.css('.pm-desc')&.text.strip,
        post_date: land_element.css('.uptime')&.text.strip,
        expired_date: expired_date,
        source_url: source_url,
        front_length: front_length.present? ? front_length.to_f : 0,
        classification: land_classifications[classification] || 8,
        images: images.presence || [],
        user: {
          email: email,
          phone_number: phone_number,
          name: username
        }
      }
    end

    def land_classifications
      @land_classifications ||= begin
        classifications_hash = {}
        LAND_CLASSIFICATION_KEYS.each_with_index do |key, index|
          classifications_hash[key] = index
        end

        classifications_hash
      end
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
end
