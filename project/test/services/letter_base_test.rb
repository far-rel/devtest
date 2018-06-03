require 'test_helper'

class LetterBaseTest < ActiveSupport::TestCase

  test 'returns price base calculated correctly' do
    test_example = <<-HTML
    <html>
      <body>
        ABCDEFGHIJKLMNOPRSTUWXYZ
        abcdefghijklmnoprstuwxyz
      </body>
    </html>"
    HTML
    address = 'http://example.com/'
    mock = Minitest::Mock.new
    mock.expect(:get, test_example, [address])
    Requester.stub :new, mock do
      array_base = LetterBase.new(address, 'a')
      assert array_base.price_base == BigDecimal('0.02')
    end

  end

end
