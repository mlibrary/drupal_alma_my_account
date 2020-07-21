require './app/models/http_client'

class FinePayer
  attr_reader :client
  def initialize(client=HttpClient.new)
    @client = client
  end
  def pay(uniqname:, amount:, reference:)
    url = "/users/#{uniqname}/fees/all?op=pay&amount=#{amount}&method=ONLINE&external_transaction_id=#{reference}"
    client.post(url)
  end
end
