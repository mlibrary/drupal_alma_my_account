require './app/models/requester'
require 'date'

class Loans
  attr_reader :uniqname
  def initialize(uniqname:, requester: Requester.new)
    @uniqname = uniqname
    @requester = requester
  end
  def list
    loans = @requester.request("/users/#{@uniqname}/loans")
    return [] if loans['total_record_count'] == 0
    loans['item_loan'].map.with_index do |loan, index|
      item_url = "/bibs/#{loan['mms_id']}/holdings/#{loan['holding_id']}/items/#{loan['item_id']}"
      item = @requester.request(item_url)
      { 
        'duedate' => format_date(loan['due_date']),
        'isbn'    => item['bib_data']['isbn'], #get from item record
        'status'      => '', #not sure how this works; see notes
        'author'  => loan['author'],
        'title'   => loan['title'],
        'barcode'   => loan['item_barcode'],
        'call_number' => loan['call_number'], 
        'description' => loan['description'], 
        'id'          => loan['mms_id'], 
        'bib_library' => '',  #don't know how this will work in Alma (MIU01/MIU30)
        'location'    => loan['library']['desc'], 
        'format'      => [item['item_data']['physical_material_type']['desc']], #get from item record
        'num'         => index, 
      }
    end
  end

  private
 
  def format_date(date)
    DateTime.parse(date).strftime("%Y%m%d %H%M")
  end
end
