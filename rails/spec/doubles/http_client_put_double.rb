require './spec/doubles/excon_response_double'
class HttpClientPutDouble
  def initialize
  end
  def put(url, body)
    {url: url, body: body}
  end
end
