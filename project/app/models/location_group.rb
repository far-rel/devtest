class LocationGroup < ApplicationRecord
  has_and_belongs_to_many :locations

  belongs_to :country
  belongs_to :panel_provider

  validates :name, presence: true
end
