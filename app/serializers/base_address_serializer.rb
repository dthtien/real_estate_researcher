class BaseAddressSerializer < ApplicationSerializer
  attributes :name, :slug, :alias_name

  attribute :logged_date do
    Time.current.strftime('%d/%m/%Y')
  end
end
