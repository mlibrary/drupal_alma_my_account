require 'spec_helper'
require 'json'
require './app/models/fines'
require './spec/doubles/requester_double'

describe Fines, 'initialize' do
  it "initializes with uniqname" do
    fines = Fines.new(uniqname: 'testuser')
    expect(fines.uniqname).to eq('testuser')
  end
end
describe Fines, 'list' do before(:each) do 
    @requests = {
      'users/jbister/fines' => JSON.parse(File.read('./spec/fixtures/jbister_fines.json')),
    }
    @expected_output = 
        {
          'title'=> 'The social life of language / Gillian Sankoff.', 
          'id'=> '',  #mms_id
          'status'=> 'Active', 
          'date'=> '20151110', #creation_time #z31-date
          'fine'=> 22.23, 
          'fine_description' => 'Overdue fine',
          'description' => '', #z30-description
          'barcode' => '93727',
          'location' => '', #z30-sub-library
          'call_number' => '', #z30-call-number
          'library' => 'Main Library', #owner?? #z31-payment-target
          'sub_library' => 'Main Library', #owner?? #z31-sub-library
          'type' => 'OVERDUEFINE', #type_code #z31-type
          'target' => 'Main Library', #owner?? #z31-payment-target or 
          'payment_cataloger' => '',
        }
  end
  it "returns correct number of items list of fines" do
    dbl = RequesterDouble.new(@requests)
    fines = Fines.new(uniqname: 'jbister', requester: dbl)
    expect(fines.list.count).to eq(3) 
  end
  it "reutrns correct items" do
    dbl = RequesterDouble.new(@requests)
    fines = Fines.new(uniqname: 'jbister', requester: dbl)
    expect(fines.list[0]).to eq(@expected_output) 
  end
end
