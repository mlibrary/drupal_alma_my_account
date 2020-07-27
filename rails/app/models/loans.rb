require './app/models/http_client_full'
require './app/models/response'
require 'date'

class Loans
  attr_reader :uniqname
  def initialize(uniqname:, client: HttpClientFull.new)
    @uniqname = uniqname
    @client = client
  end
  def url
    "/users/#{@uniqname}/loans"
  end
  def record_name
    'item_loan'
  end
  def get
    @client.get_all(url: url, record_name: record_name)
  end
  def list
    response = get
    if response.status == 200
      things = JSON.parse(response.body)
      output = []
      return Response.new(body: output) if things['total_record_count'] == 0
      things[record_name].each.with_index do |thing, index|
        item_url = "/bibs/#{thing['mms_id']}/holdings/#{thing['holding_id']}/items/#{thing['item_id']}"
        item_response = @client.get(item_url)
        item_response.status == 200 ? item = JSON.parse(item_response.body) : item = {} 

        output.push(Loan.new(thing, item, index).to_h)
        
      end
      Response.new(body: output)
    else
      response
    end
  end

end

class Loan
  attr_reader :duedate, :isbn, :status, :author, :title, :barcode, :call_number,
          :description, :id, :bib_library, :location, :format, :num
  def initialize(loan, item, index)
    @duedate = format_date(loan['due_date']) #z36-due-date z36-due-hour
    @isbn    = item.dig('bib_data', 'isbn') #get from item record
    @status      = '' #can be overdue (calculated by looking at duedate) and recalled. #z36-recall-due-date
    @author      = loan['author'] #z13-author
    @title       = loan['title'] #z13-title
    @barcode     = loan['item_barcode']  #z30-barcode
    @call_number = loan['call_number'] #z30-call-no
    @description = loan['description']  #z30-descriptions
    @id          = loan['mms_id'] #z13-doc-number
    @bib_library = ''  #z13-user-defined-5 || z13-user-defined-3
    @location    = loan['library']['desc'] #z30-sub-library
    @format      = [item.dig('item_data','physical_material_type','desc')] #z30-material
    @num         = index 
  end

  def to_h
    {
      'duedate' => @duedate,
      'isbn' => @isbn,
      'status' => @status,
      'author' => @author,
      'title' => @title,
      'barcode' => @barcode,
      'call_number' => @call_number,
      'description' => @description,
      'id' => @id,
      'bib_library' => @bib_library,
      'location' => @location,
      'format' => @format,
      'num' => @num,
    }
  end
  private
  def format_date(date)
    DateTime.parse(date).strftime("%Y%m%d %H%M")
  end
end
