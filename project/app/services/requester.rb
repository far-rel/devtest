require 'net/http'

class Requester

  def get(address)
    uri = URI.parse(address)
    Net::HTTP.get(uri)
  end

end
