# frozen_string_literal: true

PANEL_PROVIDERS_CODES = %w[times_a 10_arrays times_html].freeze

COUNTRIES = [
  { code: 'PL', panel_provider_code: 'times_a' },
  { code: 'US', panel_provider_code: '10_arrays' },
  { code: 'UK', panel_provider_code: 'times_html' }
].freeze

LOCATIONS = [
  { name: 'New York' },
  { name: 'Los Angeles' },
  { name: 'Chicago' },
  { name: 'Houston' },
  { name: 'Philadelphia' },
  { name: 'Phoenix' },
  { name: 'San Antonio' },
  { name: 'San Diego' },
  { name: 'Dallas' },
  { name: 'San Jose' },
  { name: 'Austin' },
  { name: 'Jacksonville' },
  { name: 'San Francisco' },
  { name: 'Indianapolis' },
  { name: 'Columbus' },
  { name: 'Fort Worth' },
  { name: 'Charlotte' },
  { name: 'Detroit' },
  { name: 'El Paso' },
  { name: 'Seattle' }
].freeze

LOCATION_GROUPS = [
  {
    name: 'Location Group 1',
    panel_provider_code: 'times_a',
    country_code: 'PL',
    location_names: [
      'New York',
      'Los Angeles',
      'Chicago',
      'Houston',
      'Philadelphia'
    ]
  },
  {
    name: 'Location Group 2',
    panel_provider_code: 'times_a',
    country_code: 'PL',
    location_names: [
      'Phoenix',
      'San Antonio',
      'San Diego',
      'Dallas',
      'San Jose'
    ]
  },
  {
    name: 'Location Group 3',
    panel_provider_code: '10_arrays',
    country_code: 'US',
    location_names: [
      'Austin',
      'Jacksonville',
      'San Francisco',
      'Indianapolis',
      'Columbus'
    ]
  },
  {
    name: 'Location Group 4',
    panel_provider_code: 'times_html',
    country_code: 'UK',
    location_names: [
      'Fort Worth',
      'Charlotte',
      'Detroit',
      'El Paso',
      'Seattle'
    ]
  }

].freeze

TARGET_GROUPS = [
  {
    name: 'Target Group 1',
    panel_provider_code: 'times_a',
    country_codes: %w[PL UK],
    children: [
      {
        name: 'Target Group 1.1',
        panel_provider_code: 'times_a',
        children: [
          {
            name: 'Target Group 1.1.1',
            panel_provider_code: 'times_a'
          },
          {
            name: 'Target Group 1.1.2',
            panel_provider_code: 'times_a'
          },
        ],
      },
      {
        name: 'Target Group 1.2',
        panel_provider_code: 'times_a',
        children: [
          {
            name: 'Target Group 1.2.1',
            panel_provider_code: 'times_a'
          },
          {
            name: 'Target Group 1.2.2',
            panel_provider_code: 'times_a'
          },
        ],
      },
    ]
  },
  {
    name: 'Target Group 2',
    panel_provider_code: 'times_a',
    country_codes: %w[PL US],
    children: [
      {
        name: 'Target Group 2.1',
        panel_provider_code: 'times_a',
        children: [
          {
            name: 'Target Group 2.1.1',
            panel_provider_code: 'times_a'
          },
          {
            name: 'Target Group 2.1.2',
            panel_provider_code: 'times_a'
          },
        ],
      },
      {
        name: 'Target Group 2.2',
        panel_provider_code: 'times_a',
        children: [
          {
            name: 'Target Group 2.2.1',
            panel_provider_code: 'times_a'
          },
          {
            name: 'Target Group 2.2.2',
            panel_provider_code: 'times_a'
          },
        ],
      },
    ]
  },
  {
    name: 'Target Group 3',
    panel_provider_code: '10_arrays',
    country_codes: %w[UK US],
    children: [
      {
        name: 'Target Group 3.1',
        panel_provider_code: '10_arrays',
        children: [
          {
            name: 'Target Group 3.1.1',
            panel_provider_code: '10_arrays'
          },
          {
            name: 'Target Group 3.1.2',
            panel_provider_code: '10_arrays'
          },
        ],
      },
      {
        name: 'Target Group 3.2',
        panel_provider_code: '10_arrays',
        children: [
          {
            name: 'Target Group 3.2.1',
            panel_provider_code: '10_arrays'
          },
          {
            name: 'Target Group 3.2.2',
            panel_provider_code: '10_arrays'
          },
        ],
      },
    ]
  },
  {
    name: 'Target Group 4',
    panel_provider_code: 'times_html',
    country_codes: %w[UK US],
    children: [
      {
        name: 'Target Group 4.1',
        panel_provider_code: 'times_html',
        children: [
          {
            name: 'Target Group 4.1.1',
            panel_provider_code: 'times_html'
          },
          {
            name: 'Target Group 4.1.2',
            panel_provider_code: 'times_html'
          },
        ],
      },
      {
        name: 'Target Group 4.2',
        panel_provider_code: 'times_html',
        children: [
          {
            name: 'Target Group 4.2.1',
            panel_provider_code: 'times_html'
          },
          {
            name: 'Target Group 4.2.2',
            panel_provider_code: 'times_html'
          },
        ],
      },
    ]
  }
].freeze

PANEL_PROVIDERS_CODES.each do |panel_provider_code|
  PanelProvider.create!(code: panel_provider_code)
end

COUNTRIES.each do |country|
  Country.create!(
    code: country.fetch(:code),
    panel_provider: PanelProvider.find_by!(
      code: country.fetch(:panel_provider_code)
    )
  )
end

LOCATIONS.each do |location|
  Location.create!(
    name: location.fetch(:name),
    external_id: SecureRandom.uuid,
    secret_code: SecureRandom.hex(64)
  )
end

LOCATION_GROUPS.each do |location_group|
  LocationGroup.create!(
    name: location_group[:name],
    panel_provider: PanelProvider.find_by!(
      code: location_group[:panel_provider_code]
    ),
    country: Country.find_by!(code: location_group[:country_code]),
    locations: Location.where(name: location_group[:location_names])
  )
end

def create_target_group(target_group, parent)
  created_target_group = TargetGroup.create!(
    name: target_group[:name],
    panel_provider: PanelProvider.find_by!(code: target_group[:panel_provider_code]),
    countries: Country.where(code: target_group[:country_codes]),
    external_id: SecureRandom.uuid,
    secret_code: SecureRandom.hex(64),
    parent: parent
  )
  return if target_group[:children].blank?
  target_group[:children].each do |child|
    create_target_group(child, created_target_group)
  end
end

TARGET_GROUPS.each do |target_group|
  create_target_group(target_group, nil)
end
