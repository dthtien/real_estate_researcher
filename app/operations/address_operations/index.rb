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
        AddressIndexSerializer.new(self)
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
      Address.includes(:price_loggers)
             .where(alias_name: search_address_names)
    else
      Province.includes(:price_loggers, :districts).first
    end
  end

  def search_address_names
    address_names = params[:address_names]
    striping_regex = /\"/

    return address_names.gsub(striping_regex, '') if address_names.is_a?(String)

    parsing_address_names = lambda do |address_name|
      address_name.gsub(striping_regex, '')
    end

    address_names.map(&parsing_address_names)
  end
end
