require 'spec_helper'
require 'json'
require './app/models/fines_page'
require './spec/doubles/http_client_get_double'
require './spec/doubles/excon_response_double'

describe FinesPage, 'list' do before(:each) do 
    @requests = {
      '/users/jbister/fees' => ExconResponseDouble.new(body: File.read('./spec/fixtures/jbister_fines.json')),
      '/items?item_barcode=93727' => ExconResponseDouble.new(body: File.read('./spec/fixtures/social_life_of_language.json')),
      '/items?item_barcode=15532598' => ExconResponseDouble.new(body: File.read('./spec/fixtures/the_talent_code.json'))
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
    expect(fines.list.body['charges'].count).to eq(2) 
  end
  it "reutrns correct items" do
    dbl = HttpClientGetDouble.new(@requests)
    fines = FinesPage.new(uniqname: 'jbister', client: dbl)
    expect(fines.list.body).to eq(@expected_output) 
  end
  it "handles empty request" do
    @requests[@requests.keys[0]] = ExconResponseDouble.new(body: {'total_record_count' => 0 }.to_json)
    dbl = HttpClientGetDouble.new(@requests)
    fines = FinesPage.new(uniqname: 'jbister', client: dbl)
    expect(fines.list.body).to eq({'amount'=>nil,'count'=>0,'charges'=>[],'payments'=>[]}) 
  end
  it "handles error request" do
    @not_found = JSON.parse(File.read('./spec/fixtures/user_not_found.json') )
    @requests[@requests.keys[0]] = ExconResponseDouble.new(body: @not_found.to_json, status: 400)
    dbl = HttpClientGetDouble.new(@requests)
    fines = FinesPage.new(uniqname: 'jbister', client: dbl)
    expect(fines.list.status).to eq(400) 
    expect(fines.list.body).to eq(@not_found.to_json) 
  end
  it "handles credit" do
    dbl = HttpClientGetDouble.new({
      '/users/jbister/fees' => ExconResponseDouble.new(body: File.read('./spec/fixtures/jbister_credit.json')),
    })
    expected_credit =     
    { 
      'amount' => -72.5, 
      'count' => 0,
      'charges' =>[],
      'payments' =>[]
    }
    fines = FinesPage.new(uniqname: 'jbister', client: dbl)
    expect(fines.list.body).to eq(expected_credit) 
  end
end
