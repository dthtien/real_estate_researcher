class AddressSuggestionSerializer < ApplicationSerializer
  attribute :alias_name

  attribute :name do |object|
    object.name.titleize
  end
end
