require './app/models/requester'

class Loans
  attr_reader :uniqname
  def initialize(uniqname:, requester: Requester.new)
    @uniqname = uniqname
    @requester = requester
  end
  def list
    loans = @requester.request("users/#{@uniqname}/loans")
    loans['item_loan'].map.with_index do |loan, index|
      { 
        'duedate' => loan['due_date'],
        'isbn'    => '', #get from item record
        'status'      => '', #must be calculated
        'author'  => loan['author'],
        'title'   => loan['title'],
        'barcode'   => loan['item_barcode'],
        'call_number' => loan['call_number'], 
        'description' => loan['description'], 
        'id'          => loan['mms_id'], 
        'bib_library' => '',  #don't know how this will work in Alma (MIU01/MIU30)
        'location'    => loan['library']['desc'], 
        'format'      => '', #get from item record
        'num'         => index, 
  
      }
    end
  end
end
