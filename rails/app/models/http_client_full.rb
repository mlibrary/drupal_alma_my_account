require 'forwardable'
class HttpClientFull
  extend Forwardable
  def_delegators :@client, :get, :post, :put, :del
  attr_reader :client, :limit
  
  def initialize(client: HttpClient.new, limit: 10)
    @client = client
    @limit = limit
  end

  def get_all(url:,record_name:)
    offset = 0
    output = get_range(url: url, offset: offset)
    while output['total_record_count'] > @limit + offset
      offset = offset + @limit
      my_output = get_range(url: url, offset: offset) 
      my_output[record_name].each {|x| output[record_name].push(x)}
    end 
    output
  end 

  def symbol(url)
    url.match?('\?') ? '&' : '?'   
  end 

  private 
  def get_range(url:, offset:)
    url = "#{url}#{symbol(url)}limit=#{@limit}&offset=#{offset}"
    get(url) 
  end
end
