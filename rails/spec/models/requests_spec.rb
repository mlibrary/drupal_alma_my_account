require 'spec_helper'
require 'json'
require './app/models/requests'
require './spec/doubles/http_client_get_double'
require './spec/doubles/excon_response_double'

describe Requests, 'initialize' do
  it "initializes with uniqname" do
    req = { '/users/testuser/requests' => ExconResponseDouble.new() }
    requests = Requests.new(uniqname: 'testuser', client: HttpClientGetDouble.new(req) )
    expect(requests.uniqname).to eq('testuser')
  end
end
describe Requests, 'list' do
  before(:each) do 
    @holds = JSON.parse(File.read('./spec/fixtures/connie_holds.json'))
    @bookings = JSON.parse(File.read('./spec/fixtures/jbister_requests.json'))
    @requests = {
      '/users/connie/requests' => ExconResponseDouble.new(body: @holds.to_json),
      '/users/jbister/requests' => ExconResponseDouble.new(body: @bookings.to_json),
    }
    @expected_hold_output = {
      'B' => [],  
      'H' => [ 
        {
          'title' => 'From Grieg to Brahms.',#z13-title
          'author' => 'Mason, Daniel Gregory, 1873-1953.',#z13-author
          'isbn' => '', #z13-isbn
          'type' => 'H-03', #???? [z37-request-type]-[z37-recall-type] 03 --> no recall
          'status' => 'NOT_STARTED', #z37-status
          'id' => '99948430000541', #mms ['z13-doc-number']
          'hold_rec_key' => '1332745510000521', #[z37-doc-number].[z37-item-sequence].[z37-sequence] using request_id
          'barcode' => '58782',#z30-barcode
          'pickup_loc' => 'Music Library',#z37-pickup-location
          'location' => '', #z30-sub-library???
          'call_number' => '', #z30-call-no
          'description' => '', #z30-description
          'expires' => '07/28/2018', #z37-end-request-date // last_interst_date??
          'created' => '06/28/2018', #z37-open-date
          'booking_start' => '',#z37-booking-start-date z37-booking-start-hour
          'booking_end' => '',#z37-booking-end-date z37-booking-end-hour
        }
      ]
    }
    @expected_booking_output = {
      'B' => [
        {
          'title' => 'Plain words on singing / by William Shakespeare ..',#z13-title
          'author' => 'Shakespeare, William, 1849-1931.', #z13-author
          'isbn' => '', #z13-isbn
          'type' => 'B-03', #???? [z37-request-type]-[z37-recall-type] #03 -> no recall
          'status' => 'NOT_STARTED', #z37-status
          'id' => '991408490000541', #mms ['z13-doc-number']
          'hold_rec_key' =>'1372347900006381', #[z37-doc-number].[z37-item-sequence].[z37-sequence] using request_id
          'barcode' => nil,#z30-barcode
          'pickup_loc' => 'Main Library',#z37-pickup-location
          'location' => '', #z30-sub-library??? #managed by library
          'call_number' => '', #z30-call-no
          'description' => '', #z30-description
          'expires' => '', #z37-end-request-date // last_interst_date??
          'created' => '07/16/2020', #z37-open-date
          'booking_start' => '07/17/2020 05:46 PM',#z37-booking-start-date z37-booking-start-hour
          'booking_end' => '07/21/2020 03:59 AM',#z37-booking-end-date z37-booking-end-hour
        }
      ],
      'H' => [
        {
          'title' => 'The social life of language / Gillian Sankoff.', #z13-title
          'author' => 'Sankoff, Gillian.', #z13-author
          'isbn' => '', #z13-isbn
          'type' => 'H-03', #???? [z37-request-type]-[z37-recall-type] 03 -> no recall
          'status' => 'IN_PROCESS', #z37-status
          'id' => '991040390000541', #mms ['z13-doc-number']
          'hold_rec_key' => '1372348190006381', #[z37-doc-number].[z37-item-sequence].[z37-sequence] using request_id
          'barcode' => nil, #z30-barcode
          'pickup_loc' => 'Music Library', #z37-pickup-location
          'location' => 'Main Library', #z30-sub-library??? using managed_by_library
          'call_number' => '', #z30-call-no
          'description' => '', #z30-description
          'expires' => '07/22/2020', #z37-end-request-date // last_interst_date??
          'created' => '07/16/2020', #z37-open-date
          'booking_start' => '', #z37-booking-start-date z37-booking-start-hour
          'booking_end' => '', #z37-booking-end-date z37-booking-end-hour
        }
      ]
    }
  end
  it "returns correct number of items list of holds" do
    dbl = HttpClientGetDouble.new(@requests)
    requests = Requests.new(uniqname: 'connie', client: dbl)
    expect(requests.list.body.count).to eq(2) 
    expect(requests.list.body['B'].count).to eq(0) 
    expect(requests.list.body['H'].count).to eq(1) 
  end
  it "reutrns correct items" do
    dbl = HttpClientGetDouble.new(@requests)
    requests = Requests.new(uniqname: 'connie', client: dbl)
    expect(requests.list.body).to eq(@expected_hold_output) 
  end
  it "handles empty request" do
    @holds['total_record_count'] = 0
    @holds.delete('user_request')
    resp = ExconResponseDouble.new(body: @holds.to_json)
    dbl = HttpClientGetDouble.new({@requests.keys[0] => resp})
    requests = Requests.new(uniqname: 'connie', client: dbl)
    expect(requests.list.body).to eq({'B' => [],'H' => []})
  end
  it "handles bookings" do
    dbl = HttpClientGetDouble.new(@requests)
    requests = Requests.new(uniqname: 'jbister', client: dbl)
    expect(requests.list.body).to eq(@expected_booking_output) 
  end
end
