require 'spec_helper'
require './app/models/loan_renewer'
require './spec/doubles/http_client_post_double'
require './spec/doubles/loans_double'
require './spec/doubles/excon_response_double'

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
describe LoanRenewer, 'renew' do
  it "renews a loan for a given user" do
    response = ExconResponseDouble.new(body: File.read("./spec/fixtures/renew_success.json"))
    client = HttpClientPostDouble.new({
      "/users/jbister/loans/1332733700000521?op=renew" => response
    }) 
    renewer = LoanRenewer.new(client: client, loans_class: LoansDouble)
    result = renewer.renew(uniqname: 'jbister', barcode: 67576) 
    expect(result).to eq("Renewed: item renewed")
  end

  it "returns error message if there is one" do
    response = ExconResponseDouble.new(body: File.read("./spec/fixtures/renew_error.json"))
    client = HttpClientPostDouble.new({
      "/users/jbister/loans/1332733700000521?op=renew" => response
    }) 
    renewer = LoanRenewer.new(client: client, loans_class: LoansDouble)
    result = renewer.renew(uniqname: 'jbister', barcode: 67576) 
  
    expect(result).to eq('Not Renewed: Cannot renew loan:  1346144360000521 - Item renew period exceeded.')
  end
  it "handles timeout" do
    response = ExconResponseDouble.new(body: "", status: 503)
    client = HttpClientPostDouble.new({
      "/users/jbister/loans/1332733700000521?op=renew" => response
    }) 
    renewer = LoanRenewer.new(client: client, loans_class: LoansDouble)
    result = renewer.renew(uniqname: 'jbister', barcode: 67576) 
    expect(result).to eq("Not Renewed: Unable to renew item -- no response from server")
  end
end


