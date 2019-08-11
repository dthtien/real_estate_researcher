class LandDetailsSerializer < LandSerializer
  attribute :history_prices do  |object|
    object.history_prices.as_json
  end
end
