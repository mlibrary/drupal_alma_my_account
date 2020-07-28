require './app/models/http_client_full'
require './app/models/response'
require './app/models/records_with_bib'
require 'date'

class Loans < RecordsWithBib

  def url
    "/users/#{@uniqname}/loans"
  end
  def record_key
    'item_loan'
  end

  def barcode_key
    ['item_barcode']
  end

  def list
    return @response if @response.status != 200
    output = @records.map.with_index do |th, index|
      Loan.new(loan: th[:main], bib: th[:bib], index: index).to_h
    end
    Response.new(body: output)
  end

end

class Loan
  attr_reader :duedate, :isbn, :status, :author, :title, :barcode, :call_number,
          :description, :id, :bib_library, :location, :format, :num
  def initialize(loan:, bib:, index:)
    @duedate = format_date(loan['due_date']) #z36-due-date z36-due-hour
    @isbn    = bib.dig('bib_data', 'isbn') #get from item record
    @status      = '' #can be overdue (calculated by looking at duedate) and recalled. #z36-recall-due-date
    @author      = loan['author'] #z13-author
    @title       = loan['title'] #z13-title
    @barcode     = loan['item_barcode']  #z30-barcode
    @call_number = loan['call_number'] #z30-call-no
    @description = loan['description']  #z30-descriptions
    @id          = loan['mms_id'] #z13-doc-number
    @bib_library = ''  #z13-user-defined-5 || z13-user-defined-3
    @location    = loan['library']['desc'] #z30-sub-library
    @format      = [bib.dig('item_data','physical_material_type','desc')] #z30-material
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
