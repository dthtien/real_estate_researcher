class Land < ApplicationRecord
  extend FriendlyId
  acts_as_paranoid
  friendly_id :alias_title, use: :slugged

  has_many :history_prices, dependent: :destroy
  belongs_to :street
  belongs_to :ward
  belongs_to :district
  belongs_to :province
  belongs_to :user, optional: true

  enum classification: [
    'ban can ho chung cu', 'ban nha rieng', 'ban nha biet thu, lien ke',
    'ban nha mat pho', 'ban dat nen du an', 'ban dat',
    'ban trang trai, khu nghi duong', 'ban kho, nha xuong',
    'ban loai bat dong san khac'
  ].freeze

  scope :with_history_prices, (lambda do
    select('lands.*, COUNT(history_prices.id) history_prices_count')
      .left_outer_joins(:history_prices)
      .group(:id)
  end)

  scope :top_fluctuate, -> { with_history_prices.limit(10) }

  scope :new_lands_count, -> { new_lands.size }

  scope :new_lands, (lambda do
    where(post_date: [Time.current.beginning_of_day..Time.current.end_of_day])
  end)

  scope :calculatable, (lambda do
    where('lands.total_price > 0 AND lands.acreage > 0')
  end)

  scope :with_street_name, (lambda do
    select('lands.*, addresses.name address')
      .joins(:street)
      .group(:id, 'addresses.name')
  end)

  scope :rendering, (lambda do |params|
    calculatable.order(params)
  end)

  scope :average_price_calculate, (lambda do
    avg = calculatable.average(:square_meter_price)
    avg.is_a?(Numeric) ? avg : 0
  end)

  scope :with_acreage_range, (lambda do |acreage_range|
    where(acreage: (acreage_range.first...acreage_range.last))
  end)

  scope :with_price_range, (lambda do |total_price_range|
    where(total_price: (total_price_range.first...total_price_range.last))
  end)

  scope :with_front_length_range, (lambda do |front_length_range|
    where(front_length: (front_length_range.first...front_length_range.last))
  end)

  scope :with_classification, (lambda do |classification|
    where(classification: classification)
  end)

  scope :today_hot_deal, (lambda do
    new_lands.calculatable.order(:total_price).first
  end)

  scope :trusted_deal, (lambda do
    joins(:user).where(users: { agency: false })
                .where.not(user_id: nil)
                .today_hot_deal
  end)

  scope :search, (lambda do |keyword|
    joins(:street).where('
      lands.address_detail ILIKE ? OR
      lands.title ILIKE ? OR
      lands.alias_title ILIKE ? OR
      addresses.name ILIKE ? OR
      addresses.alias_name ILIKE ?',
      "%#{keyword}%", "%#{keyword}%", "%#{keyword}%", "%#{keyword}%",
      "%#{keyword}%"
    )
  end)

  def full_address
    "#{street.name.titleize} - #{ward.name.titleize} - #{district.name.titleize}"
  end

  delegate :agency, :email, :name, :phone_number, to: :user, allow_nil: true

  def self.xml_generate
    File.open('sitemap.xml', 'a') do |f|
      Address.pluck(:slug).each do |s|
        f.write("
          <url>
            <loc>https://toplands.tech/app/lands/#{s}</loc>
            <changefreq>daily</changefreq>
          </url>
        ")
      end
    end
  end
end
