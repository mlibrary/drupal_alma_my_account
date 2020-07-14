require './app/models/requester'
require 'date'

class Fines
  attr_reader :uniqname
  def initialize(uniqname:, requester: Requester.new)
    @uniqname = uniqname
    @requester = requester
  end
  def url
    "/users/#{@uniqname}/fees"
  end
  def list
    fines = @requester.request(url)
    return [] if fines['total_record_count'] == 0
    fines['fee'].map do |fine|
      item = @requester.request("/items?item_barcode=#{fine['barcode']['value']}")
      element(main: fine, bib: item)
    end
  end

  def element(main:, bib: nil)
    {
      'barcode'     => main['barcode']['value'],
      'call_number' => bib['holding_data']['call_number'], #z30-call-number
      'date'        => format_date(main['creation_time']), #z31-date #not sure
      'description' => '', #z30-description
      'fine'        => main['balance'], #z31-net-sum
      'fine_description' => main['type']['desc'],  #z31-description
      'id'=> bib['bib_data']['mms_id'],  #mms_id
      'library'     => main['owner']['desc'],  #z31-payment-target 
      'location'    => bib['item_data']['library']['desc'], #z30-sub-library
      'payment_cataloger' => '',  #z31-payment-cataloger
      'status'=> main['status']['desc'], #z31-status
      'sub_library' => main['owner']['desc'], #z31-sublibrary
      'target'      => main['owner']['desc'], #z31-payment-target or z31-sub-library
      'title'=> main['title'], #z13-title
      'type'        => main['type']['value'], #z31-type
    }
  end 

  private
 
  def format_date(date)
    DateTime.parse(date).strftime("%Y%m%d")
  end
end
