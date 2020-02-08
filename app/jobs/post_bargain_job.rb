class PostBargainJob < ApplicationJob
  include ActionView::Helpers::NumberHelper
  FRONT_END_URL = 'https://toplands.tech/app/lands/'.freeze
  MONITORING_DISTRICT_SLUGS = %w[ho-chi-minh thu-duc quan-12 quan-9].freeze

  def perform
    Address.where(slug: MONITORING_DISTRICT_SLUGS).each do |address|
      land = address.lands.today_hot_deal
      post!(land) if land.present?
    end
    land = Land.trusted_deal
    post!(land) if land.present? && land.user_id.present?
  end

  private

  def post!(land)
    price = number_to_currency(land.total_price).gsub('$', '')
    content = <<-TXT
      #{land.description}
      Địa chỉ: #{land.full_address}
      Giá: #{price} VND
    TXT
    return if land.blank?

    Facebook::Page.new.post!(content, link: FRONT_END_URL + land.slug)
  end
end
