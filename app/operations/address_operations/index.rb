class AddressOperations::Index
  attr_accessor :params, :addresses

  def initialize(params = {})
    @params = params
  end

  def execute
    if params[:address_names].present?
      @addresses = MixAddressGraphSerializer.new(parse_addresses)
                                            .serializable_hash
    else
      @addresses = ProvinceSerializer.new(Province.first)
    end

    self
  end

  private

  def parse_addresses
    quering_addresses = []
    params[:address_names].each do |alias_name|
      quering_addresses += Address.where(alias_name: alias_name)
    end

    quering_addresses.uniq
  end
end
