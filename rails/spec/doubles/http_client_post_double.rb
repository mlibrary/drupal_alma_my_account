require 'byebug'
class HttpClientPostDouble
  def initialize(requests={})
    @requests = requests
  end
  def post(url)
    @requests[url]
  end
end
