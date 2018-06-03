require 'test_helper'

class NodeBaseTest < ActiveSupport::TestCase

  test 'returns price base calculated correctly' do
    test_example = <<-HTML
    <html><body><div>Test</div></body></html>
    HTML
    address = 'http://example.com/'
    mock = Minitest::Mock.new
    mock.expect(:get, test_example, [address])
    Requester.stub :new, mock do
      array_base = NodeBase.new(address)
      assert array_base.price_base == BigDecimal('0.04')
    end

  end

end
