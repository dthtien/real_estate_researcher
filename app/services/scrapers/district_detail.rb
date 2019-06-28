class Scrapers::DistrictDetail < Scrapers::Base
  HCM_REAL_ESTATE_URL = 'nha-dat-ban-tp-hcm'.freeze
  BASE_ADDRESS_ELEMENT = '#RightMainContent__productCountByContext_bodyContainer #divCountByAreas ul a'.freeze

  def call
    province_name = 'Hồ Chí Minh'.freeze
    province = Province.find_or_create_by(
      name: province_name,
      alias_name: VietnameseSanitizer.execute!(province_name)
    )
    list_urls(HCM_REAL_ESTATE_URL).map do |link|
      distric_name = link[:name]
      p distric_name
      ward_links = list_urls(link[:href])
      district = District.find_or_create_by(
        name: distric_name,
        alias_name: VietnameseSanitizer.execute!(distric_name),
        parent_id: province.id
      )

      ward_links.each do |ward_link|
        ward_name = ward_link[:name]
        ward = Ward.find_or_initialize_by(
          name: ward_name,
          alias_name: VietnameseSanitizer.execute!(ward_name),
          parent_id: district.id,
          scrapping_link: ward_link[:href]
        )
        page_count = total_page(page_content(ward_link[:href]))
        ward.total_page = page_count
        ward.save!
      end
    end
  end

  private

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
