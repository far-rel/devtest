require 'test_helper'

class ArrayBaseTest < ActiveSupport::TestCase

  test 'returns price base calculated correctly' do
    test_json = {
      one: (1..11).to_a,
      two: (1..10).to_a,
      three: (1..9).to_a,
      nested_1: [
        (1..11).to_a,
        (1..10).to_a,
        (1..9).to_a
      ],
      nested_2: {
        one: (1..11).to_a,
        two: (1..10).to_a,
        three: (1..9).to_a
      }
    }
    address = 'http://example.com/'
    mock = Minitest::Mock.new
    mock.expect(:get, test_json.to_json, [address])
    Requester.stub :new, mock do
      array_base = ArrayBase.new(address, 10)
      assert array_base.price_base == BigDecimal('3')
    end

  end

end
