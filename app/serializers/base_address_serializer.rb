class BaseAddressSerializer < ApplicationSerializer
  attributes :name, :slug, :alias_name, :land_only_price, :apartment_price,
             :house_price, :farm_price

  attribute :logged_date do
    Time.current.strftime('%d/%m/%Y')
  end
end
