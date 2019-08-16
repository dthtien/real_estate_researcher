class LandDetailsSerializer < LandSerializer
  attribute :history_prices do  |object|
    object.history_prices.order('posted_date desc').as_json
  end
end
