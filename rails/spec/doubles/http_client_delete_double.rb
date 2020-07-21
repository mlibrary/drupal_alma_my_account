require 'byebug'
class HttpClientDeleteDouble
  attr_reader :requests
  def initialize(requests={})
    @requests = requests
  end
  def delete(url)
    @requests[url]
  end
end
