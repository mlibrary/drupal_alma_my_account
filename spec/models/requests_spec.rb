require 'spec_helper'
require 'json'
require './app/models/requests'
require './spec/doubles/requester_double'

describe Requests, 'initialize' do
  it "initializes with uniqname" do
    requests = Requests.new(uniqname: 'testuser')
    expect(requests.uniqname).to eq('testuser')
  end
end
describe Requests, 'list' do
  before(:each) do 
    @requests = {
      'users/connie/requests' => JSON.parse(File.read('./spec/fixtures/connie_holds.json')),
    }
    @expected_output = {
      'B' => [],  
      'H' => [ 
        {
          'title' => 'From Grieg to Brahms.',
          'author' => 'Mason, Daniel Gregory, 1873-1953.',
          'isbn' => '', #find_other_way?
          'type' => 'H-01', #???? [z37-request-type]-[z37-recall-type]
          'status' => 'NOT_STARTED', #z37-status
          'id' => '99948430000541', #mms ['z13-doc-number']
          'hold_rec_key' => '1332745510000521', #[z37-doc-number].[z37-item-sequence].[z37-sequence] using request_id
          'barcode' => '58782',
          'pickup_loc' => 'Music Library',
          'location' => '', #z30-sub-library???
          'call_number' => '', #z30-call-no
          'description' => '', #z30-description
          'expires' => '07/28/2018', #z37-end-request-date // last_interst_date??
          'created' => '06/28/2018', #z37-open-date
          'booking_start' => '',
          'booking_end' => '',
        }
      ]
    }
  end
  it "returns correct number of items list of loans" do
    dbl = RequesterDouble.new(@requests)
    requests = Requests.new(uniqname: 'connie', requester: dbl)
    expect(requests.list.count).to eq(2) 
    expect(requests.list['B'].count).to eq(0) 
    expect(requests.list['H'].count).to eq(1) 
  end
  it "reutrns correct items" do
    dbl = RequesterDouble.new(@requests)
    requests = Requests.new(uniqname: 'connie', requester: dbl)
    expect(requests.list).to eq(@expected_output) 
  end
end
