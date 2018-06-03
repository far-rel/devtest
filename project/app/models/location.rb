class Location < ApplicationRecord
  has_and_belongs_to_many :location_groups

  validates :name, presence: true
  validates :external_id, presence: true, uniqueness: true
  validates :secret_code, presence: true

  def self.locations_for_country(country_code)
    Location
      .joins(location_groups: :country)
      .where(countries: {code: country_code.upcase})
      .where('countries.panel_provider_id == location_groups.panel_provider_id')
      .uniq
  end

end
