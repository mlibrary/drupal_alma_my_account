require 'spec_helper'
require 'json'
require './app/models/loans'
require './spec/doubles/requester_double'

describe Holds, 'initialize' do
  it "initializes with uniqname" do
#    loans = Loans.new(uniqname: 'testuser')
#    expect(loans.uniqname).to eq('testuser')
  end
end
describe Holds, 'list' do
  before(:each) do 
    @requests = {
      'users/connie/holds' => JSON.parse(File.read('./spec/fixtures/connie_holds.json')),
      #'bibs/991246960000541/holdings/225047730000541/items/235047720000541' =>
      #  JSON.parse(File.read('./spec/fixtures/basics_of_singing_item.json')),
      #'bibs/991408490000541/holdings/229209090000521/items/235561180000541' =>
      #  JSON.parse(File.read('./spec/fixtures/plain_words_on_singing_item.json')),
    }
    @expected_output = {
      'B' => [],  
      'H' => [ 
        {
          'title' => 'From Grieg to Brahms'
          'author' => 'Mason, Daniel Gregory, 1873-1953.' 
          'isbn' => '' #find_other_way?
          'type' => 'H-01' #???? [z37-request-type]-[z37-recall_type]
          'status' => 'NOT_STARTED' #z37-status
          'id' => '99948430000541' #mms ['z13-doc-number']
          'hold_rec_key' => '0000000000000000000' #z37-doc-number???
          'barcode' => '58782'
          'pickup_loc' => 'Music Library'
          'location' => 'Hatcher Graduate' #z30-sub-library???
          'call_number' => 'HV6457 .G46 2011' #z30-call-no
          'description' => '' #z30-description
          'expires' => '09/26/2012' #z37-end-request-date
          'created' => '03/26/2012' #z37-open-date
          'booking_start' => ''
          'booking_end' => ''
        }
      ]
    }
  end
  it "returns correct number of items list of loans" do
    #dbl = RequesterDouble.new(@requests)
    #loans = Loans.new(uniqname: 'jbister', requester: dbl)
    #expect(loans.list.count).to eq(2) 
  end
  it "reutrns correct items" do
    #dbl = RequesterDouble.new(@requests)
    #loans = Loans.new(uniqname: 'jbister', requester: dbl)
    #expect(loans.list).to eq(@expected_output) 
  end
end
