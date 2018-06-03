require 'test_helper'

class CalculatePriceCommandTest < ActiveSupport::TestCase

  def stubbed_bases(letter, array, nodes, &block)
    letter_base = Minitest::Mock.new
    letter_base.expect :price_base, BigDecimal(letter)
    node_base = Minitest::Mock.new
    node_base.expect :price_base, BigDecimal(nodes)
    array_base = Minitest::Mock.new
    array_base.expect :price_base, BigDecimal(array)
    LetterBase.stub :new, letter_base do
      NodeBase.stub :new, node_base do
        ArrayBase.stub :new, array_base, &block
      end
    end
  end

  test "calculates price correctly for given parameters - times_a panel only" do
    params = {
      country_code: countries(:pl).code,
      target_group_id: target_groups(:parent).id,
      locations: [
        { id: locations(:krakow).id, panel_size: 100 },
        { id: locations(:gdansk).id, panel_size: 300 }
      ]
    }
    stubbed_bases(1, 0, 0) do
      command = CalculatePriceCommand.new(params)
      assert command.calculate == (1000 + 300 * 100 + 2 * 500)
    end

  end

  test "calculates price correctly for given parameters - 10_arrays panel only" do
    params = {
      country_code: countries(:pl).code,
      target_group_id: target_groups(:parent).id,
      locations: [
        { id: locations(:krakow).id, panel_size: 100 },
        { id: locations(:gdansk).id, panel_size: 300 }
      ]
    }
    stubbed_bases(0, 1, 0) do
      command = CalculatePriceCommand.new(params)
      assert command.calculate == (100 * 100 + 1 * 500)
    end

  end

  test "calculates price correctly for given parameters - times_html panel only" do
    params = {
      country_code: countries(:pl).code,
      target_group_id: target_groups(:parent).id,
      locations: [
        { id: locations(:krakow).id, panel_size: 100 },
        { id: locations(:gdansk).id, panel_size: 300 }
      ]
    }
    stubbed_bases(0, 0, 1) do
      command = CalculatePriceCommand.new(params)
      assert command.calculate == (1 * 500)
    end

  end

  test "calculates price correctly for given parameters - all panels" do
    params = {
      country_code: countries(:pl).code,
      target_group_id: target_groups(:parent).id,
      locations: [
        { id: locations(:krakow).id, panel_size: 100 },
        { id: locations(:gdansk).id, panel_size: 300 }
      ]
    }
    stubbed_bases(1, 1, 1) do
      command = CalculatePriceCommand.new(params)
      assert command.calculate == (1000 + 400 * 100 + 4 * 500)
    end

  end

end
