require 'spec_helper'
require 'json'
require './app/models/history'
require './spec/doubles/http_client_get_double'

describe History, 'initialize' do
  it "initializes with uniqname" do
    history = History.new(uniqname: 'testuser')
    expect(history.uniqname).to eq('testuser')
  end
end
describe History, 'list' do
  before(:each) do 
    @requests = {
      #'/users/jbister/history' => JSON.parse(File.read('./spec/fixtures/history.json')),
    }
    @expected_output = []
  end
  #it "returns correct number of items list of history" do
  #  dbl = HttpClientGetDouble.new(@requests)
  #  history = History.new(uniqname: 'jbister', client: dbl)
  #  expect(history.list.count).to eq(2) 
  #end
  it "reutrns nil for appropriate items" do
    dbl = HttpClientGetDouble.new(@requests)
    history = History.new(uniqname: 'jbister', client: dbl)
    no = [ 
      'fine_description',
      'fine',
      'pickup_loc',
      '#duedate',
      'urgency',
      'booking_start',
      'booking_end',
      'created',
      'expires',
      'tags',
      'pickup_loc',
      'Holdings',
      'duedate',
      'status',
      'message',
      'date',
    ]
    no.each { |n| expect(history.list[0][n]).to be_nil }
  end
  #it "handles empty history" do
  #  @requests[@requests.keys[0]]['total_record_count'] = 0
  #  dbl = HttpClientGetDouble.new(@requests)
  #  history = History.new(uniqname: 'jbister', client: dbl)
  #  expect(history.list).to eq([])
  #end
end
