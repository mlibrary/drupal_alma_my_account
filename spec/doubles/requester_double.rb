require 'byebug'
class RequesterDouble
  def initialize(requests={})
    @requests = requests
  end
  def request(url)
    @requests[url]
  end
end
