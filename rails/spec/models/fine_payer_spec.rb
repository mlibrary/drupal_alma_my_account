require 'spec_helper'
require './app/models/fine_payer'
require './spec/doubles/http_client_post_double'

describe FinePayer, 'initialize' do
  it "has default client of HttpClient" do
    payer = FinePayer.new
    expect(payer.client.class.name).to eq('HttpClient')
  end
end
describe FinePayer, 'pay(uniqname:, amount:, reference:)' do
  it "posts appropriate data to client" do
    uniqname = 'testname'
    amount = 50.11
    reference = 1234567
    client = HttpClientPostDouble.new({
      "/users/#{uniqname}/fees/all?op=pay&amount=#{amount}&method=ONLINE&external_transaction_id=#{reference}" => 'success'
    })
    payer = FinePayer.new(client)
    expect(payer.pay(uniqname: uniqname, amount: amount, reference: reference)).to eq('success')
  end
end
