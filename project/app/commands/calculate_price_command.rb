class CalculatePriceCommand

  COUNTRY_BASE_PRICE = 1000
  TARGET_GROUP_BASE_PRICE = 500
  LOCATION_BASE_PRICE = 100

  def initialize(params)
    @country = Country.includes(:panel_provider)
                      .find_by!(code: params[:country_code].upcase)
    @target_groups = load_target_groups(params)
    @locations = load_locations(params)
    @price_bases = price_bases
  end

  def calculate
    country_price + locations_price + target_group_price
  end

  private

  def price_bases
    {
      'times_a' => LetterBase.new('http://time.com', 'a').price_base,
      '10_arrays' => ArrayBase.new(
      'http://openlibrary.org/search.json?q=the+lord+of+the+rings', 10
      ).price_base,
      'times_html' => NodeBase.new('http://time.com').price_base
    }
  end

  def country_price
    @price_bases[@country.panel_provider.code] * COUNTRY_BASE_PRICE
  end

  def locations_price
    @locations.reduce(0) do |price, location|
      panel_provider = location[:model].location_groups
                                       .select do |group|
                                         group.country_id == @country.id
                                       end
                                       .first
                                       .panel_provider
      price + (@price_bases[panel_provider.code] * LOCATION_BASE_PRICE * location[:panel_size])
    end
  end

  def target_group_price
    @target_groups.reduce(0) do |price, group|
      price + @price_bases[group.panel_provider.code] * TARGET_GROUP_BASE_PRICE
    end
  end

  def load_locations(params)
    @country.locations
            .where(id: params[:locations].map {|location| location[:id] })
            .includes(location_groups: :panel_provider)
            .uniq
            .to_a
            .map do |location|
              {
                model: location,
                panel_size: params[:locations].select do |loc|
                  loc[:id] == location.id
                end.first.fetch(:panel_size)
              }
            end
  end

  def load_target_groups(params)
    root_target_group = @country.target_groups.find(params[:target_group_id])
    descendants = TargetGroup
                  .where(id: root_target_group.all_descendant_ids)
                  .includes(:panel_provider)
                  .to_a
    descendants.prepend(root_target_group)
  end

end
