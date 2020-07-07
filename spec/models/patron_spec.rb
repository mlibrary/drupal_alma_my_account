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
  it "gets correct patron info" do
    requests = {
      'users/jbister/?user_id_type=all_unique&view=full&expand=none' => JSON.parse(File.read('./spec/fixtures/jbister_patron.json'))
    }
    dbl = RequesterDouble.new(@requests)
  #  expected_patron =  Hash.new (
  #       'uniqname' => 'mrio',
  #       'first_name' => ' Monique',
  #       'last_name' => 'Rio',
  #       'email' => 'mrio@umich.edu',
  #       'college' => 'MIU50',
  #       'bor_status' => '02',
  #       'booking_permission' => 'Y',
  #       'campus' => 'UMAA',
  #       'barcode' => '000000377644',
  #       'address_1' => 'Library Info Tech - AIM',
  #       'address_2' => '300 Hatcher North',
  #       'zip' => '481091190',
  #       'phone' => '555-555-5555',
  #       'expires' => '20201010',
  #    )
    patron = Patron.new(uniqname: 'jbister')
    expect(patron.list.empty?).to be_falsey
  end
end

