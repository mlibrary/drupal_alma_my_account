require './app/models/http_client'
require './app/models/response'
require 'forwardable'

class HttpClientFull
  extend Forwardable
  def_delegators :@client, :get, :post, :put, :del
  attr_reader :client, :limit
  
  def initialize(client: HttpClient.new, limit: 10)
    @client = client
    @limit = limit
  end

  def get_all(url:, record_key:)
    offset = 0
    output = get_range(url: url, offset: offset)
    if output.status == 200
      body = JSON.parse(output.body)
      while  body['total_record_count'] > @limit + offset
        offset = offset + @limit
        my_output = get_range(url: url, offset: offset) 
        if my_output.status == 200
          my_body = JSON.parse(my_output.body)
          my_body[record_key].each {|x| body[record_key].push(x)}
        else
          return my_output #return error
        end
      end 
      Response.new(body: body.to_json) #return good response
    else
      output #return error
    end
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
