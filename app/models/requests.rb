require './app/models/requester'
require 'date'

class Requests
  attr_reader :uniqname
  def initialize(uniqname:, requester: Requester.new)
    @uniqname = uniqname
    @requester = requester
  end
  def list
    requests = @requester.request("/users/#{@uniqname}/requests")
    output = {'B' => [], 'H' => [] }
    return output if requests['total_record_count'] == 0
    requests['user_request'].map.with_index do |request, index|
      my_req = { 
          'title' => request['title'],
          'author' => request['author'],
          'isbn' => '', #find_other_way?
          'type' => type(request['request_type']), #???? [z37-request-type]-[z37-recall-type]
          'status' => request['request_status'], #z37-status
          'id' => request['mms_id'], #mms ['z13-doc-number']
          'hold_rec_key' => request['request_id'], #[z37-doc-number].[z37-item-sequence].[z37-sequence] using request_id
          'barcode' => request['barcode'],
          'pickup_loc' => request['pickup_location'],
          'location' => '', #z30-sub-library???
          'call_number' => '', #z30-call-no
          'description' => '', #z30-description
          'expires' => format_date(request['last_interest_date']), #z37-end-request-date // last_interst_date??
          'created' => format_date(request['request_time']), #z37-open-date
          'booking_start' => '',
          'booking_end' => '',
      }
      case request['request_type']
      when 'HOLD'
        output['H'].push(my_req) 
      end
    end
    output
  end

  private
 
  def format_date(date)
    DateTime.parse(date).strftime("%m/%d/%Y") if date
  end

  def type(request_type)
    case request_type
    when 'HOLD'
      'H-01'
    end
  end
end
