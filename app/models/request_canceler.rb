require './app/models/http_client'

class RequestCanceler
  attr_reader :client 
  def initialize(client=HttpClient.new)
    @client = client
  end
  def cancel(uniqname:, request_id:)
    url = "/users/#{uniqname}/requests/#{request_id}?reason=patrons_request"
    @client.delete(url)
  end
end
