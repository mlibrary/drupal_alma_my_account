require './app/models/http_client'
require 'date'

class Loans
  attr_reader :uniqname
  def initialize(uniqname:, client: HttpClient.new)
    @uniqname = uniqname
    @client = client
  end
  def list
    loans = get
    return [] if loans['total_record_count'] == 0
    loans['item_loan'].map.with_index do |loan, index|
      item_url = "/bibs/#{loan['mms_id']}/holdings/#{loan['holding_id']}/items/#{loan['item_id']}"
      item = @client.get(item_url)
      { 
        'duedate' => format_date(loan['due_date']), #z36-due-date z36-due-hour
        'isbn'    => item['bib_data']['isbn'], #get from item record
        'status'      => '', #can be overdue (calculated by looking at duedate) and recalled. #z36-recall-due-date
        'author'  => loan['author'], #z13-author
        'title'   => loan['title'], #z13-title
        'barcode'   => loan['item_barcode'],  #z30-barcode
        'call_number' => loan['call_number'], #z30-call-no
        'description' => loan['description'],  #z30-descriptions
        'id'          => loan['mms_id'], #z13-doc-number
        'bib_library' => '',  #z13-user-defined-5 || z13-user-defined-3
        'location'    => loan['library']['desc'], #z30-sub-library
        'format'      => [item['item_data']['physical_material_type']['desc']], #z30-material
        'num'         => index, 
      }
    end
  end

  def get
    @client.get("/users/#{@uniqname}/loans")
  end

  private
 
  def format_date(date)
    DateTime.parse(date).strftime("%Y%m%d %H%M")
  end
end
