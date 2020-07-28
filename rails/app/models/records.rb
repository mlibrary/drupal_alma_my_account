require './app/models/http_client_full'
require './app/models/response'

class Records
  attr_reader :uniqname, :records, :response
  def initialize(uniqname:, client: HttpClientFull.new)
    @uniqname = uniqname
    @client = client
    @response = @client.get_all(url:url, record_name: record_key)
    @body = JSON.parse(@response.body) 
    if @response.status == 200 && @body[record_key]
      @records = fetch 
    else
      @records = [] 
    end
  end

  def url
  end

  def record_key
  end

  def list
  end

  private
  def fetch
    @body[record_key] 
  end
end
