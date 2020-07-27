require 'spec_helper'
require 'json'
require './app/models/patron'
require './spec/doubles/http_client_get_double'
require './spec/doubles/excon_response_double'

describe Patron, 'initialize' do
  it "initializes with uniqname" do
    patron = Patron.new(uniqname: 'testuser')
    expect(patron.uniqname).to eq('testuser')
  end
end
describe Patron, 'list' do
  before(:each) do
    @body = JSON.parse(File.read('./spec/fixtures/johns_patron.json'))
    @requests = {
      '/users/johns?user_id_type=all_unique&view=full&expand=none' => ExconResponseDouble.new(body: @body.to_json)
    }
  end
  it "gets correct patron info" do
    expected_patron =  {
         'uniqname' => 'johns',
         'first_name' => 'John', #z303-name
         'last_name' => 'Smith', #z303-name
         'email' => 'johns@mylib.org', #z304-email
         'college' => nil, #z303-home-library (and other things)
         'bor_status' => nil, #z305-bor-status
         'booking_permission' => nil, #z305-booking-permission
         'campus' => 'Main',  #z303-profile-id
         'barcode' => nil, #z303-id
         'address_1' => 'Graduate Library', #z304-address-1
         'address_2' => '3598 N. Buckingham Road', #z304-address-2
         'zip' => '85054', #z304-zip
         'phone' => '18005882300', #z304-telephone
         'expires' => '20300116', #z305-expiry-date
      }
   dbl = HttpClientGetDouble.new(@requests)
   patron = Patron.new(uniqname: 'johns', client: dbl)
   expect(patron.list.body).to eq(expected_patron)
  end
  it 'handles empty phone block' do
   @body['contact_info']['phone'] = []
   resp = ExconResponseDouble.new(body: @body.to_json)
   dbl = HttpClientGetDouble.new({@requests.keys[0] => resp})
   patron = Patron.new(uniqname: 'johns', client: dbl)
   expect(patron.list.body['phone']).to eq('')
  end
  it 'handles empty email block' do
   @body['contact_info']['email'] = []
   resp = ExconResponseDouble.new(body: @body.to_json)
   dbl = HttpClientGetDouble.new({@requests.keys[0] => resp})
   patron = Patron.new(uniqname: 'johns', client: dbl)
   expect(patron.list.body['email']).to eq('')
  end

  it 'handles missing expiry_date' do
   @body.delete('expiry_date')
   resp = ExconResponseDouble.new(body: @body.to_json)
   dbl = HttpClientGetDouble.new({@requests.keys[0] => resp})
   patron = Patron.new(uniqname: 'johns', client: dbl)
   expect(patron.list.body['expires']).to eq('')
  end 
end

