require './app/models/requester'
require 'date'

class Fines
  attr_reader :uniqname
  def initialize(uniqname:, requester: Requester.new)
    @uniqname = uniqname
    @requester = requester
  end
  def list
    fines = @requester.request("users/#{@uniqname}/fines")
    fines['fee'].map do |fine|
      { 
        'title'=> fine['title'], #z13-title
        'id'=> '',  #mms_id
        'status'=> fine['status']['desc'], #z31-status
        'date'        => format_date(fine['creation_time']), #z31-date #not sure
        'fine'        => fine['balance'], #z31-net-sum
        'fine_description' => fine['type']['desc'],  #z31-description
        'description' => '', #z30-description
        'barcode'     => fine['barcode']['value'],
        'location'    => '', #z30-sub-library
        'call_number' => '', #z30-call-number
        'library'     => fine['owner']['desc'],  #z31-payment-target 
        'sub_library' => fine['owner']['desc'], #z31-sublibrary
        'type'        => fine['type']['value'], #z31-type
        'target'      => fine['owner']['desc'], #z31-payment-target or z31-sub-library
        'payment_cataloger' => '',  #z31-payment-cataloger
      }
    end
  end

  private
 
  def format_date(date)
    DateTime.parse(date).strftime("%Y%m%d")
  end
end
