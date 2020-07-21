require 'spec_helper'
require './app/models/loan_renewer'
require './spec/doubles/http_client_post_double'
require './spec/doubles/loans_double'

describe LoanRenewer, 'initialize' do
  it "has default client of HttpClient instance" do
    payer = LoanRenewer.new
    expect(payer.client.class.name).to eq('HttpClient')
  end
  it "has default loans_class of Loans" do
    renewer = LoanRenewer.new
    expect(renewer.loans_class.class.name).to eq('Class')
    expect(renewer.loans_class.name).to eq('Loans')
  end
end
describe LoanRenewer, 'initialize' do
  it "renews a loan for a given user" do
    client = HttpClientPostDouble.new({
      "/users/jbister/loans/1332733700000521?op=renew" => "success"
    }) 
    renewer = LoanRenewer.new(client: client, loans_class: LoansDouble)
    result = renewer.renew(uniqname: 'jbister', barcode: 67576) 
    expect(result).to eq('success')
  end
end
