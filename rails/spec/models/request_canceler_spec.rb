require 'spec_helper'
require './app/models/request_canceler'
require './spec/doubles/http_client_delete_double'

describe RequestCanceler, 'initialize' do
  it "has default client of HttpClient instance" do
    payer = RequestCanceler.new
    expect(payer.client.class.name).to eq('HttpClient')
  end
end

describe RequestCanceler, 'initialize' do
  it "renews a loan for a given user" do
    client = HttpClientDeleteDouble.new({
      "/users/connie/requests/1332745510000521?reason=patrons_request" => "success"
    }) 
    canceler = RequestCanceler.new(client)
    result = canceler.cancel(uniqname: 'connie', request_id: '1332745510000521') 
    expect(result).to eq('success')
  end
end