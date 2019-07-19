class AddressSuggestionSerializer < ApplicationSerializer
  attributes :alias_name

  attribute :name do |object|
    object.name.titleize
  end
end
