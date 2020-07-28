require 'byebug'
class HttpClientGetDouble
  def initialize(requests={})
    @requests = requests
  end
  def get(url)
    @requests[url]
  end
  def get_all(url:, record_key:)
    @requests[url]
  end
end
