require 'spec_helper'
require './app/models/request_canceler'
require './spec/doubles/http_client_delete_double'
require './spec/doubles/excon_response_double'

describe RequestCanceler, 'initialize' do
  it "has default client of HttpClient instance" do
    payer = RequestCanceler.new
    expect(payer.client.class.name).to eq('HttpClient')
  end
end

describe RequestCanceler, 'initialize' do
  it "cancels a request for a given user" do
    client = HttpClientDeleteDouble.new({
      "/users/connie/requests/1332745510000521?reason=CancelledAtPatronRequest" => ExconResponseDouble.new(body: '{}', status: 204)
    }) 
    canceler = RequestCanceler.new(client)
    result = canceler.cancel(uniqname: 'connie', request_id: '1332745510000521') 
    expect(result).to eq(true)
  end
  it "handles a failed request" do
    client = HttpClientDeleteDouble.new({
      "/users/connie/requests/1332745510000521?reason=CancelledAtPatronRequest" => ExconResponseDouble.new(body:File.read('./spec/fixtures/cancel_request_fail.json'), status: 400)
    }) 
    canceler = RequestCanceler.new(client)
    result = canceler.cancel(uniqname: 'connie', request_id: '1332745510000521') 
    expect(result).to eq(false)
  end
end
