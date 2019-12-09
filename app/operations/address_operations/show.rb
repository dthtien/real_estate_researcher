class AddressOperations::Show
  attr_reader :params
  WARDS = 'wards'.freeze
  DISTRICTS = 'districts'.freeze
  STREETS = 'streets'.freeze

  def initialize(params = {})
    @params = params
  end

  def execute
    @address = scope.calculatable
                    .includes(:price_loggers, sub_addresses_including)
                    .find_by_slug(params[:id])
    self
  end

  def address
    @address ||= Address.find_by_slug(params[:id])
  end

  def rendering_data
    AddressSerializer.new(address, params: JSON.parse(params[:order] || '{}'))
                     .serializable_hash
  end

  private

  def scope
    @scope ||= address.class
  end

  def sub_addresses_including
    @sub_addresses_including ||= case scope.class.to_s
                                 when 'District'
                                   WARDS
                                 when 'Ward'
                                   STREETS
                                 else
                                  ''
                                 end
  end
end
