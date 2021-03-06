require './app/models/http_client_full'
require './app/models/response'
require './app/models/records'
require 'date'

class Requests < Records

  def url
    "/users/#{@uniqname}/requests"
  end

  def record_key
    "user_request"
  end

  def list
    return @response if @response.status != 200
    output = {'B' => [], 'H' => [] }
    @records.each.with_index do |record, index|
      record_inst = Request.for(record)
      case record_inst.class.name
      when 'HoldRequest'
        output['H'].push(record_inst.to_h) 
      when 'BookingRequest'
        output['B'].push(record_inst.to_h) 
      end
    end
    Response.new(body: output)
  end

end

class Request
  attr_reader :title, :author, :isbn, :type, :status, :mms, :request_id, :barcode,
              :pickup_loc, :location, :call_number, :description, :created, :type,
              :expires
  def initialize(request)
    @request =  request

    @title = request['title']
    @author = request['author']
    @isbn = '' #find_other_way?
    @type = type
    @status = request['request_status'] #z37-status
    @id = request['mms_id'] #mms ['z13-doc-number']
    @request_id = request['request_id'] #[z37-doc-number].[z37-item-sequence].[z37-sequence] using request_id
    @barcode = request['barcode']
    @pickup_loc = request['pickup_location']
    @location = request['managed_by_library'] #z30-sub-library???
    @call_number = '' #z30-call-no
    @description = '' #z30-description
    @expires = expires
    @created = format_date(request['request_time']) #z37-open-date
    @booking_start = booking_start 
    @booking_end = booking_end
  end
 
  
  def to_h
    {
      'title' => @title,
      'author' => @author,
      'isbn' => @isbn,
      'type' => @type,
      'status' => @status, #z37-status
      'id' => @id, #mms ['z13-doc-number']
      'hold_rec_key' => @request_id, #[z37-doc-number].[z37-item-sequence].[z37-sequence] using request_id
      'barcode' => @barcode,
      'pickup_loc' => @pickup_loc,
      'location' => @location, #z30-sub-library???
      'call_number' => @call_number, #z30-call-no
      'description' => @description, #z30-description
      'expires' => @expires, #z37-end-request-date // last_interst_date??
      'created' => @created, #z37-open-date
      'booking_start' => @booking_start,
      'booking_end' => @booking_end,
    }
  end 
  def self.for(request)
    case request['request_type']
    when 'HOLD'
      HoldRequest.new(request)
    when 'BOOKING'
      BookingRequest.new(request)
    end
    
  end
  private
  def expires
    ''
  end 
  def booking_start
    ''
  end
  def booking_end
    ''
  end
  def format_date(date)
    DateTime.parse(date).strftime("%m/%d/%Y") if date
  end
end

class HoldRequest < Request
  def expires
    format_date(@request['last_interest_date'])
  end

  def type
    'H-03'
  end
end

class BookingRequest < Request
  def booking_start
    format_datetime(@request['booking_start_date'])
  end
  def booking_end
    format_datetime(@request['booking_end_date'])
  end
  def type
    'B-03'
  end
  private
  
  def format_datetime(date)
    DateTime.parse(date).strftime("%m/%d/%Y %I:%M %p") if date
  end
end
