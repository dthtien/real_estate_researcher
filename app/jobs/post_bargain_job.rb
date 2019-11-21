class PostBargainJob < ApplicationJob
  include ActionView::Helpers::NumberHelper

  def perform
    land = Land.new_lands.calculatable.order(:total_price).first
    price = number_to_currency(land.total_price).gsub('$', '')
    content = <<-TXT
      #{land.description}

      Price: #{price} VND
    TXT

    Facebook::Page.new.post!(content)
  end
end
