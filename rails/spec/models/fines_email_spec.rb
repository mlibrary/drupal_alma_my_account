require 'spec_helper'
require 'json'
require './app/models/fines_email'
require './spec/doubles/http_client_get_double'
require './spec/doubles/excon_response_double.rb'

describe FinesEmail, 'initialize' do
  it "initializes with uniqname" do
    request = {'/users/testuser/fees' => ExconResponseDouble.new(body: {'total_record_count' => 0 }.to_json )}
    dbl = HttpClientGetDouble.new(request)
    fines = FinesEmail.new(uniqname: 'testuser', client: dbl)
    
    expect(fines.uniqname).to eq('testuser')
  end
end
describe FinesEmail, 'list' do before(:each) do 
    @requests = {
      '/users/jbister/fees' => ExconResponseDouble.new(body: File.read('./spec/fixtures/jbister_fines.json')),
      '/items?item_barcode=93727' => ExconResponseDouble.new(body: File.read('./spec/fixtures/social_life_of_language.json')),
      '/items?item_barcode=15532598' => ExconResponseDouble.new(body: File.read('./spec/fixtures/the_talent_code.json'))
    }
    @expected_output = 
        {
          'title'=> 'The social life of language / Gillian Sankoff.', #z13-title 
          'id'=> '991040390000541',  #mms_id #z13-doc-id
          'status'=> 'Active', #z31-status
          'date'=> '20151110', #creation_time #z31-date
          'fine'=> 22.23, #z31-net-sum
          'fine_description' => 'Overdue fine', #z31-description
          'description' => '', #z30-description: Description of the item (for multi-volume monographs or serial items); Probably should be handled with enumeration chronology?
          'barcode' => '93727', #z30-barcode
          'location' => 'Main Library', #z30-sub-library
          'call_number' => 'P35 .S2', #z30-call-number
          'library' => 'Main Library', #owner?? #z31-payment-target
          'sub_library' => 'Main Library', #owner?? #z31-sub-library
          'type' => 'OVERDUEFINE', #type_code #z31-type
          'target' => 'Main Library', #owner?? #z31-payment-target or 
          'payment_cataloger' => '', #z31-payment-cataloger
        }
  end
  it "returns correct number of items list of fines" do
    dbl = HttpClientGetDouble.new(@requests)
    fines = FinesEmail.new(uniqname: 'jbister', client: dbl)
    expect(fines.list.body.count).to eq(2) 
  end
  it "reutrns correct items" do
    dbl = HttpClientGetDouble.new(@requests)
    fines = FinesEmail.new(uniqname: 'jbister', client: dbl)
    expect(fines.list.body[0]).to eq(@expected_output) 
  end
  it "handles empty request" do
    @requests[@requests.keys[0]] = ExconResponseDouble.new( body: {'total_record_count' => 0 }.to_json) 
    dbl = HttpClientGetDouble.new(@requests)
    fines = FinesEmail.new(uniqname: 'jbister', client: dbl)
    expect(fines.list.body).to eq([]) 
  end
  it "handles credit" do
    dbl = HttpClientGetDouble.new({
      '/users/jbister/fees' => ExconResponseDouble.new(body: File.read('./spec/fixtures/jbister_credit.json')),
    })
    fines = FinesEmail.new(uniqname: 'jbister', client: dbl)
    expect(fines.list.body).to eq([]) 
  end
end
