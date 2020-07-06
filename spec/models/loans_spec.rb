require 'spec_helper'
require 'json'
require './app/models/loans'

describe Loans, 'initialize' do
  it "initializes with uniqname" do
    loans = Loans.new(uniqname: 'testuser')
    expect(loans.uniqname).to eq('testuser')
  end
end
describe Loans, 'list' do
  before(:each) do 
    @json = JSON.parse(File.read("./spec/fixtures/loans.json")) 
    @expected_output = 
      [
        {
          "duedate"=>"2018-07-28T22:00:00Z", 
          "isbn"=>"", 
          "status"=>"", 
          "author"=>"Schmidt, Jan,", 
          "title"=>"Basics of singing / [compiled by] Jan Schmidt.", 
          "barcode"=>"67576", 
          "call_number"=>"MT825 .B27 1984", 
          "description"=>nil, 
          "id"=>"991246960000541", 
          "bib_library"=>"", 
          "location"=>"Music Library", 
          "format"=>"", 
          "num"=>0
        }, {
          "duedate"=>"2018-07-28T22:00:00Z", 
          "isbn"=>"", 
          "status"=>"", 
          "author"=>"Shakespeare, William,", 
          "title"=>"Plain words on singing / by William Shakespeare ..", 
          "barcode"=>"0919242913", 
          "call_number"=>"MT820 .S53", 
          "description"=>nil, 
          "id"=>"991408490000541", 
          "bib_library"=>"", 
          "location"=>"Music Library", 
          "format"=>"", 
          "num"=>1
        }
      ]
  end
  it "returns correct number of items list of loans" do
    dbl = double("Requester", :request => @json)
    loans = Loans.new(uniqname: 'testuser', requester: dbl)
    expect(loans.list.count).to eq(2) 
  end
  it "reutrns correct items" do
    dbl = double("Requester", :request => @json)
    loans = Loans.new(uniqname: 'testuser', requester: dbl)
    
    expect(loans.list).to eq(@expected_output) 
  end
end
