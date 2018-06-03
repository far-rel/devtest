require 'test_helper'

class RequesterTest < ActiveSupport::TestCase

  test 'makes get request to the web with given address' do
    body = 'Test response'
    address = 'http://example.com/' 
    stub_request(:get, address).to_return(body: body)
    assert Requester.new().get(address) == body
  end

end
