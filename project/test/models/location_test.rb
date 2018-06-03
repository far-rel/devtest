require 'test_helper'

class LocationTest < ActiveSupport::TestCase

  test '.locations_for_country returns locations for given country with same panel provider' do
    result = Location.locations_for_country(countries(:pl).code)
    assert result == [locations(:krakow), locations(:gdansk)].sort_by(&:id)
  end

end
