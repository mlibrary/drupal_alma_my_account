require 'spec_helper'
require 'json'
require './app/models/fines'
require './spec/doubles/http_client_get_double'

describe Fines, 'initialize' do
  it "initializes with uniqname" do
    fines = Fines.new(uniqname: 'testuser')
    expect(fines.uniqname).to eq('testuser')
  end
end
describe Fines, 'list' do before(:each) do 
    @requests = {
      '/users/jbister/fees' => JSON.parse(File.read('./spec/fixtures/jbister_fines.json')),
      '/items?item_barcode=93727' => JSON.parse(File.read('./spec/fixtures/social_life_of_language.json')),
      '/items?item_barcode=15532598' => JSON.parse(File.read('./spec/fixtures/the_talent_code.json'))
    }
    @expected_output = 
        {
          'title'=> 'The social life of language / Gillian Sankoff.', 
          'id'=> '991040390000541',  #mms_id
          'status'=> 'Active', 
          'date'=> '20151110', #creation_time #z31-date
          'fine'=> 22.23, 
          'fine_description' => 'Overdue fine',
          'description' => '', #z30-description: Description of the item (for multi-volume monographs or serial items); Probably should be handled with enumeration chronology?
          'barcode' => '93727',
          'location' => 'Main Library', #z30-sub-library
          'call_number' => 'P35 .S2', #z30-call-number
          'library' => 'Main Library', #owner?? #z31-payment-target
          'sub_library' => 'Main Library', #owner?? #z31-sub-library
          'type' => 'OVERDUEFINE', #type_code #z31-type
          'target' => 'Main Library', #owner?? #z31-payment-target or 
          'payment_cataloger' => '',
        }
  end
  it "returns correct number of items list of fines" do
    dbl = HttpClientGetDouble.new(@requests)
    fines = Fines.new(uniqname: 'jbister', client: dbl)
    expect(fines.list.count).to eq(2) 
  end
  it "reutrns correct items" do
    dbl = HttpClientGetDouble.new(@requests)
    fines = Fines.new(uniqname: 'jbister', client: dbl)
    expect(fines.list[0]).to eq(@expected_output) 
  end
  it "handles empty request" do
    @requests[@requests.keys[0]]['total_record_count'] = 0
    dbl = HttpClientGetDouble.new(@requests)
    fines = Fines.new(uniqname: 'jbister', client: dbl)
    expect(fines.list).to eq([]) 
  end
end
