require 'json'
require './app/models/http_client'

class RequestCanceler
  attr_reader :client 
  def initialize(client=HttpClient.new)
    @client = client
  end
  def cancel(uniqname:, request_id:)
    url = "/users/#{uniqname}/requests/#{request_id}?reason=CancelledAtPatronRequest"
    response =  @client.delete(url)
    if response.status == 503
       false
    else
      body = JSON.parse(response.body)
      if body["errorsExist"]
        return false
      else
        return true
      end 
    end 
  end
end
