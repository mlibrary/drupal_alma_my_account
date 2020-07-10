require 'spec_helper'
require 'json'
require './app/models/patron'
require './spec/doubles/requester_double'

describe Patron, 'initialize' do
  it "initializes with uniqname" do
    patron = Patron.new(uniqname: 'testuser')
    expect(patron.uniqname).to eq('testuser')
  end
end
describe Patron, 'list' do
  before(:each) do
    @requests = {
      '/users/johns?user_id_type=all_unique&view=full&expand=none' => JSON.parse(File.read('./spec/fixtures/johns_patron.json'))
    }
  end
  it "gets correct patron info" do
    expected_patron =  {
         'uniqname' => 'johns',
         'first_name' => 'John',
         'last_name' => 'Smith',
         'email' => 'johns@mylib.org',
         'college' => nil, #Don't know
         'bor_status' => nil, #Don't know
         'booking_permission' => nil, #Don't know
         'campus' => 'Main', 
         'barcode' => nil, #Don't know
         'address_1' => 'Graduate Library',
         'address_2' => '3598 N. Buckingham Road',
         'zip' => '85054',
         'phone' => '18005882300',
         'expires' => '20300116',
      }
   dbl = RequesterDouble.new(@requests)
   patron = Patron.new(uniqname: 'johns', requester: dbl)
   expect(patron.list).to eq(expected_patron)
  end
  it 'handles empty phone block' do
    @requests.values[0]['contact_info']['phone'] = []
   dbl = RequesterDouble.new(@requests)
   patron = Patron.new(uniqname: 'johns', requester: dbl)
   expect(patron.list['phone']).to eq('')
  end
  it 'handles empty email block' do
    @requests.values[0]['contact_info']['email'] = []
   dbl = RequesterDouble.new(@requests)
   patron = Patron.new(uniqname: 'johns', requester: dbl)
   expect(patron.list['email']).to eq('')
  end

  it 'handles missing expiry_date' do
   @requests.values[0].delete('expiry_date')
   dbl = RequesterDouble.new(@requests)
   patron = Patron.new(uniqname: 'johns', requester: dbl)
   expect(patron.list['expires']).to eq('')
  end 
end

