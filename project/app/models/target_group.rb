class TargetGroup < ApplicationRecord
  belongs_to :parent, class_name: 'TargetGroup', optional: true
  belongs_to :panel_provider
  has_many :children, class_name: 'TargetGroup', foreign_key: :parent_id
  has_and_belongs_to_many :countries

  validates :name, presence: true
  validates :external_id, presence: true, uniqueness: true
  validates :secret_code, presence: true
  validate :prevent_cycles, on: :update

  COUNTRY_QUERY = <<-SQL.freeze
    WITH RECURSIVE
      cte(id, "name", external_id, parent_id, secret_code, panel_provider_id, created_at, updated_at)
      AS (
      SELECT tg.id,
             tg."name",
             tg.external_id,
             tg.parent_id,
             tg.secret_code,
             tg.panel_provider_id,
             tg.created_at,
             tg.updated_at
      FROM target_groups tg
      WHERE tg.id IN (:starting_ids)
      UNION ALL
      SELECT tg.id,
             tg."name",
             tg.external_id,
             tg.parent_id,
             tg.secret_code,
             tg.panel_provider_id,
             tg.created_at,
             tg.updated_at
      FROM target_groups tg
      JOIN cte ON cte.id = tg.parent_id
    )
    SELECT * FROM cte WHERE cte.panel_provider_id = :panel_provider_id;
  SQL

  DESCENDANTS_QUERY = <<-SQL.freeze
    WITH RECURSIVE
      cte(id, parent_id)
      AS (
      SELECT tg.id,
             tg.parent_id
      FROM target_groups tg
      WHERE tg.parent_id = :id
      UNION ALL
      SELECT tg.id,
             tg.parent_id
      FROM target_groups tg
      JOIN cte ON cte.id = tg.parent_id
    )
    SELECT * FROM cte;
  SQL

  def self.groups_for_country(county_code)
    country = Country.find_by(code: county_code.upcase)
    starting_ids = country.target_groups.where(parent_id: nil).pluck(:id)
    TargetGroup.find_by_sql(
      [COUNTRY_QUERY,
       {
         starting_ids: starting_ids,
         panel_provider_id: country.panel_provider_id
       }]
    )
  end

  def all_descendant_ids
    TargetGroup.find_by_sql([DESCENDANTS_QUERY, { id: id }]).map(&:id)
  end

  def prevent_cycles
    if all_descendant_ids.include?(parent_id)
      errors.add(:parent_id, "can't be descendant")
    elsif parent_id == id
      errors.add(:parent_id, "can't be self")
    end
  end

end
