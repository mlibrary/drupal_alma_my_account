require './app/models/http_client_full'
require './app/models/response'
require 'date'

class Loans
  attr_reader :uniqname
  def initialize(uniqname:, client: HttpClientFull.new)
    @uniqname = uniqname
    @client = client
  end
  def list
    response = get
    if response.status == 200
      loans = JSON.parse(response.body)
      return Response.new(body: []) if loans['total_record_count'] == 0
      
      output = loans['item_loan'].map.with_index do |loan, index|
        item_url = "/bibs/#{loan['mms_id']}/holdings/#{loan['holding_id']}/items/#{loan['item_id']}"
        item_response = @client.get(item_url)
        item_response.status == 200 ? item = JSON.parse(item_response.body) : item = {} 
        { 
          'duedate' => format_date(loan['due_date']), #z36-due-date z36-due-hour
          'isbn'    => item.dig('bib_data', 'isbn'), #get from item record
          'status'      => '', #can be overdue (calculated by looking at duedate) and recalled. #z36-recall-due-date
          'author'  => loan['author'], #z13-author
          'title'   => loan['title'], #z13-title
          'barcode'   => loan['item_barcode'],  #z30-barcode
          'call_number' => loan['call_number'], #z30-call-no
          'description' => loan['description'],  #z30-descriptions
          'id'          => loan['mms_id'], #z13-doc-number
          'bib_library' => '',  #z13-user-defined-5 || z13-user-defined-3
          'location'    => loan['library']['desc'], #z30-sub-library
          'format'      => [item.dig('item_data','physical_material_type','desc')], #z30-material
          'num'         => index, 
        }
      end
      Response.new(body: output)
    else
      response
    end
  end

  def get
    @client.get_all(url:"/users/#{@uniqname}/loans",record_name: 'item_loan')
  end

  private
 
  def format_date(date)
    DateTime.parse(date).strftime("%Y%m%d %H%M")
  end
end
