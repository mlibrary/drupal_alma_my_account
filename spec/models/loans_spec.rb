require 'spec_helper'
require 'json'
require './app/models/loans'
require './spec/doubles/http_client_get_double'

describe Loans, 'initialize' do
  it "initializes with uniqname" do
    loans = Loans.new(uniqname: 'testuser')
    expect(loans.uniqname).to eq('testuser')
  end
end
describe Loans, 'list' do
  before(:each) do 
    @requests = {
      '/users/jbister/loans' => JSON.parse(File.read('./spec/fixtures/loans.json')),
      '/bibs/991246960000541/holdings/225047730000541/items/235047720000541' =>
        JSON.parse(File.read('./spec/fixtures/basics_of_singing_item.json')),
      '/bibs/991408490000541/holdings/229209090000521/items/235561180000541' =>
        JSON.parse(File.read('./spec/fixtures/plain_words_on_singing_item.json')),
    }
    @expected_output = 
      [
        {
          "duedate"=>"20180728 2200", #z36-due-date z36-due-hour
          "isbn"=>"0028723406",  #z13-isbn
          "status"=>"", 
          "author"=>"Schmidt, Jan,", #z13-author
          "title"=>"Basics of singing / [compiled by] Jan Schmidt.", #z13-title
          "barcode"=>"67576", #z30-barcode
          "call_number"=>"MT825 .B27 1984", #z30-call-no
          "description"=>nil, #z30-description
          "id"=>"991246960000541", #z13-doc-number
          "bib_library"=>"", #z13-user-defined-5 || z13-user-defined-3
          "location"=>"Music Library",  #z30-sub-library
          "format"=>['Music Score'], #z30-material
          "num"=>0
        }, {
          "duedate"=>"20180728 2200", 
          "isbn"=>9781234567897, 
          "status"=>"", 
          "author"=>"Shakespeare, William,", 
          "title"=>"Plain words on singing / by William Shakespeare ..", 
          "barcode"=>"0919242913", 
          "call_number"=>"MT820 .S53", 
          "description"=>nil, 
          "id"=>"991408490000541", 
          "bib_library"=>"", 
          "location"=>"Music Library", 
          "format"=>["Book"], 
          "num"=>1
        }
      ]
  end
  it "returns correct number of items list of loans" do
    dbl = HttpClientGetDouble.new(@requests)
    loans = Loans.new(uniqname: 'jbister', client: dbl)
    expect(loans.list.count).to eq(2) 
  end
  it "reutrns correct items" do
    dbl = HttpClientGetDouble.new(@requests)
    loans = Loans.new(uniqname: 'jbister', client: dbl)
    expect(loans.list).to eq(@expected_output) 
  end
  it "handles empty loans" do
    @requests[@requests.keys[0]]['total_record_count'] = 0
    dbl = HttpClientGetDouble.new(@requests)
    loans = Loans.new(uniqname: 'jbister', client: dbl)
    expect(loans.list).to eq([])
  end
end
