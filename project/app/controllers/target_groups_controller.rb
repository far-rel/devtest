class TargetGroupsController < ApplicationController

  before_action :authenticate!, only: [:evaluate]

  def show
    @locations = TargetGroup.groups_for_country(params[:country_code])
    render json: @locations.as_json(only: fields)
  end

  def evaluate
    @price = CalculatePriceCommand.new(evaluate_params).calculate
    render json: { price: @price }
  end

  private

  def fields
    if authenticated?
      %i[id name external_id secret_code]
    else
      %i[id name external_id]
    end
  end

  def evaluate_params
    {
      country_code: params.require(:country_code),
      target_group_id: params.require(:target_group_id),
      locations: params.require(:locations).map do |location|
        {
          id: location.require(:id),
          panel_size: location.require(:panel_size)
        }
      end
    }
  end

end
