require 'spec_helper'
require './app/models/http_client_full'
require './spec/doubles/http_client_get_double'
require 'json'
require 'byebug'

describe HttpClientFull, 'initialize' do
  it "initializes with HttpClient by default" do
    client = HttpClientFull.new
    expect(client.client.class.name).to eq('HttpClient')
  end
  it "has HttpClientMethods" do
    client = HttpClientFull.new
    expect(client.methods).to include(:get)
    expect(client.methods).to include(:del)
    expect(client.methods).to include(:post)
    expect(client.methods).to include(:put)
  end

  it "has default limit of 10" do
    client = HttpClientFull.new
    expect(client.limit).to eq(10)
  end
end

describe HttpClientFull, 'get_all' do
  it "gets all of a given get" do
    dbl = HttpClientGetDouble.new({
      '/users/jbister/loans?limit=1&offset=0' => JSON.parse(File.read('./spec/fixtures/jbister_loans0.json')),
      '/users/jbister/loans?limit=1&offset=1' => JSON.parse(File.read('./spec/fixtures/jbister_loans1.json')),
    })

    client = HttpClientFull.new(client: dbl, limit: 1)
    output = client.get_all(url: '/users/jbister/loans', record_name:'item_loan')
    expect(output).to eq(JSON.parse(File.read('./spec/fixtures/loans.json')))
  end
end
describe HttpClientFull, 'symbol(url)' do
  it "outputs ? if no question mark in url" do
    client = HttpClientFull.new
    expect(client.symbol('/users/so_and_so/loans')).to eq('?')    
  end 
  it "output & if ? is in url" do
    client = HttpClientFull.new
    expect(client.symbol('/users/so_and_so/loans?op=something_or_other')).to eq('&')    
  end
end 
