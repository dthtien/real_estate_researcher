class Scrapers::DistrictDetail < Scrapers::Base
  HCM_REAL_ESTATE_URL = 'nha-dat-ban-tp-hcm'.freeze
  BASE_ADDRESS_ELEMENT = '#RightMainContent__productCountByContext_bodyContainer #divCountByAreas ul a'.freeze

  def call
    province = update_province
    list_urls(HCM_REAL_ESTATE_URL).map do |link|
      district = update_district(link: link, province: province)
      ward_links = list_urls(link[:href])
      ward_links.each do |ward_link|
        update_ward(link: ward_link, district: district)
      end
    end
  end

  private

  def update_province(province_name: 'Hồ Chí Minh'.freeze)
    Province.find_or_create_by(
      name: province_name,
      alias_name: VietnameseSanitizer.execute!(province_name)
    )
  end

  def update_district(link:, province:)
    distric_name = link[:name]
    p distric_name
    District.find_or_create_by(
      name: distric_name,
      alias_name: VietnameseSanitizer.execute!(distric_name),
      parent_id: province.id
    )
  end

  def update_ward(link:, district:)
    ward_name = link[:name]
    ward = Ward.find_or_initialize_by(
      name: ward_name,
      alias_name: VietnameseSanitizer.execute!(ward_name),
      parent_id: district.id,
      scrapping_link: link[:href]
    )

    ward.update_total_page!(total_page(page_content(link[:href])))
  end

  def list_urls(url)
    page = page_content(url)
    page.css(BASE_ADDRESS_ELEMENT)
        .map { |a| { name: a.text.strip.downcase, href: a['href'] } }
  end

  def total_page(page)
    return 0 if page.blank?

    last_page = page.css('.background-pager-right-controls a').last
    last_page.present? ? last_page['href'].to_s.gsub(/[^\d]+/, '').to_i : 1
  end
end
