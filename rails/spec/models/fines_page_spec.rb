require 'spec_helper'
require 'json'
require './app/models/fines_page'
require './spec/doubles/http_client_get_double'

describe FinesPage, 'list' do before(:each) do 
    @requests = {
      '/users/jbister/fees' => JSON.parse(File.read('./spec/fixtures/jbister_fines.json')),
      '/items?item_barcode=93727' => JSON.parse(File.read('./spec/fixtures/social_life_of_language.json')),
      '/items?item_barcode=15532598' => JSON.parse(File.read('./spec/fixtures/the_talent_code.json'))
    }
    @expected_output = 
    { 
      'amount' => 25, 
      'count' => 2,
      'charges' =>[
        {
          'author' => 'Sankoff, Gillian.', #z13-author
          'barcode' => '93727', #z30-barcode
          'date'=> '20151110', #creation_time #z31-date #CHECK don't think this gets used
          'fine'=> 22.23,  #z31-sum (without the parens)
          'fine_description' => 'Overdue fine',  #z31-description
          'href' => 'https://api-na.hosted.exlibrisgroup.com/almaws/v1/users/jbister/fees/121319140000521', #??????? getAttribute('href')
          'id'=> '991040390000541',  #mms_id z30-doc-number
          'library' => 'Main Library', #owner?? #z31-payment-target
          'payment_cataloger' => '', #z31-payment-cataloger #CHECK don't think this gets used
          'status'=> 'Active',  #z31-status
          'sub_library' => 'Main Library', #owner?? #z31-sub-library
          'title' => 'The social life of language / Gillian Sankoff.', #z13-title 
          'type' => 'OVERDUEFINE', #type_code #z31-type
          'value' => '(22.23)', #z31-sum (with the parens)

        },
        {
          'author' => 'Coyle, Daniel.', #z13-author
          'barcode' => '15532598', #z30-barcode
          'date'=> '20160531', #creation_time #z31-date #CHECK don't think this gets used
          'fine'=> 2.77,  #z31-sum (without the parens)
          'fine_description' => 'Overdue fine',  #z31-fine-description
          'href' => 'https://api-na.hosted.exlibrisgroup.com/almaws/v1/users/jbister/fees/690390050000521', #??????? getAttribute('href') link to cash request
          'id'=> '991544900000541',  #mms_id z30-doc-number
          'library' => 'Music Library', #owner?? #z31-payment-target
          'payment_cataloger' => '', #z31-payment-cataloger #CHECK don't think this gets used
          'status'=> 'Active',  #z31-status
          'sub_library' => 'Music Library', #owner?? #z31-sub-library
          'title' => "The talent code : greatest isn't born. It's grown. Here's how. / Daniel Coyle.", #z13-title 
          'type' => 'OVERDUEFINE', #type_code #z31-type
          'value' => '(2.77)', #z31-sum (with the parens)

        }
      ],
      'payments' =>[
        {
          'transaction' => '24010000521',#z31-payment-identifier (using external transaction id)
        },
        {
          'transaction' => '43010000521', #z31-payment-identifier (using external transaction id)
        }
      ]
    }
  end
  it "returns correct number of items list of fines" do
    dbl = HttpClientGetDouble.new(@requests)
    fines = FinesPage.new(uniqname: 'jbister', client: dbl)
    expect(fines.list['charges'].count).to eq(2) 
  end
  it "reutrns correct items" do
    dbl = HttpClientGetDouble.new(@requests)
    fines = FinesPage.new(uniqname: 'jbister', client: dbl)
    expect(fines.list).to eq(@expected_output) 
  end
  it "handles empty request" do
    @requests[@requests.keys[0]]['total_record_count'] = 0
    dbl = HttpClientGetDouble.new(@requests)
    fines = FinesPage.new(uniqname: 'jbister', client: dbl)
    expect(fines.list).to eq([]) 
  end
  it "handles credit" do
    dbl = HttpClientGetDouble.new({
      '/users/jbister/fees' => JSON.parse(File.read('./spec/fixtures/jbister_credit.json')),
    })
    expected_credit =     
    { 
      'amount' => -72.5, 
      'count' => 0,
      'charges' =>[],
      'payments' =>[]
    }
    fines = FinesPage.new(uniqname: 'jbister', client: dbl)
    expect(fines.list).to eq(expected_credit) 
  end
end
