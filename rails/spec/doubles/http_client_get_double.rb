require './spec/doubles/excon_response_double'
class HttpClientGetDouble
  def initialize(requests={})
    @requests = requests
    @default = ExconResponseDouble.new
  end
  def get(url)
   req = @requests[url]
   req ? req : @default
  end
  def get_all(url:, record_key:)
    get(url)
  end
end
