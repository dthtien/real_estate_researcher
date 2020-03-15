class PostBargainJob < ApplicationJob
  include ActionView::Helpers::NumberHelper
  FRONT_END_URL = 'https://toplands.tech/app/lands/'.freeze
  NOT_PROVIDE = 'Không cung cấp'.freeze
  MONITORING_DISTRICT_SLUGS = %w[thu-duc quan-12 quan-9].freeze

  def perform
    Address.where(slug: MONITORING_DISTRICT_SLUGS).each do |address|
      land = address.lands.today_hot_deal
      post!(land) if land.present?
    end
    land = Land.trusted_deal
    post!(land) if land.present? && land.user_id.present?
  end

  private

  def message(land)
    price = number_to_currency(land.total_price).gsub('$', '')
    link = FRONT_END_URL + land.slug

    <<-TXT
      #{land.description}
      Địa chỉ: #{land.full_address}
      Giá: #{price} VND
      Người bán: #{land.name&.strip || NOT_PROVIDE}
      SĐT: #{land.phone_number || NOT_PROVIDE}
      Email: #{land.email || NOT_PROVIDE}
      Xem chi tiết tại: #{link}
    TXT
  end

  def post!(land)
    page = Facebook::Page.new
    options = {}

    if land.images.present?
      options[:attached_media] = page.upload_images!(land.images).map do |id|
        { media_fbid: id }
      end
    else
      options[:link] = FRONT_END_URL + land.slug
    end

    page.post!(message(land), options)
  end
end
