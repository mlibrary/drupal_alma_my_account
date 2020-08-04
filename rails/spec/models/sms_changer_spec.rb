require 'spec_helper'
require 'json'
require './app/models/sms_changer'
require './spec/doubles/http_client_put_double'
require './spec/doubles/excon_response_double'
require './spec/doubles/patron_double'

describe SmsChanger, 'initialize' do
  it "initializes with patron" do
    dbl = PatronDouble.new(uniqname: 'test')
    smsChanger = SmsChanger.new(patron: dbl, client: HttpClientPutDouble.new)
    expect(smsChanger.patron).to eq(dbl)
  end
end

describe SmsChanger, 'set' do
  before :each do 
    @jbister = File.read('./spec/fixtures/jbister_patron.json')
    @phone_entry = JSON.parse('{ "preferred": "true", "preferred_sms": "true", "segment_type": "Internal", "phone_number": "15555555555", "phone_type": [ { "value": "mobile" } ] }')
  end
  it "sets a preferred-sms status of given phone number" do
    patron = PatronDouble.new(uniqname: 'jbister', response: @jbister)
    sent_update = JSON.parse(@jbister)
    sent_update["contact_info"]["phone"].push(@phone_entry)
    client = HttpClientPutDouble.new()

    resp = SmsChanger.new(patron: patron, client: client).set(@phone_entry["phone_number"])
    expect(resp[:body]).to eq(sent_update.to_json)
  end
end

describe SmsChanger, 'unset' do
  it "removes  preferred-sms status of all phone numbers"
end
