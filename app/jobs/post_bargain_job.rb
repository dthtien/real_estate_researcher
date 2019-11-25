class PostBargainJob < ApplicationJob
  include ActionView::Helpers::NumberHelper
  FRONT_END_URL = 'https://toplands.tech/app/lands/'.freeze

  def perform
    land = Land.new_lands.calculatable.order(:total_price).first
    price = number_to_currency(land.total_price).gsub('$', '')
    content = <<-TXT
      #{land.description}

      Price: #{price} VND
    TXT
    return if land.blank?

    Facebook::Page.new.post!(content, link: FRONT_END_URL + land.slug)
  end
end
