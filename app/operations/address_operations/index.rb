class AddressOperations::Index
  attr_accessor :params, :addresses, :id

  def initialize(params = {})
    @params = params
    @address_names = params[:address_names]
    @order = JSON.parse(params[:order] || '{}')
    @id = 'term'
  end

  def execute
    @addresses ||= parsing_addresses
    self
  end

  def parsed_addresses
    @parsed_addresses =
      if @address_names.present?
        MixAddressGraphSerializer.new(self)
      else
        ProvinceSerializer.new(@addresses, params: @order)
      end
  end

  def latest_logs
    @latest_logs ||= addresses.map(&:latest_log)
  end

  private

  def parsing_addresses
    if @address_names.present?
      Address.includes(:price_loggers).where(alias_name: params[:address_names])
    else
      Province.includes(:districts, :price_loggers).first
    end
  end
end
