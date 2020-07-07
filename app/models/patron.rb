require './app/models/requester'

class Patron
  attr_reader :uniqname
  def initialize(uniqname:, requester: Requester.new)
    @uniqname = uniqname
    @requester = requester
  end
  def list
    patron = @requester.request("users/#{@uniqname}/?user_id_type=all_unique&view=full&expand=none")
    #patron['item_loan'].map.with_index do |loan, index|
    #  item = @requester.request(item_url)
    #  { 
    #    'duedate' => format_date(loan['due_date']),
    #    'isbn'    => item['bib_data']['isbn'], #get from item record
    #    'status'      => '', #not sure how this works; see notes
    #    'author'  => loan['author'],
    #    'title'   => loan['title'],
    #    'barcode'   => loan['item_barcode'],
    #    'call_number' => loan['call_number'], 
    #    'description' => loan['description'], 
    #    'id'          => loan['mms_id'], 
    #    'bib_library' => '',  #don't know how this will work in Alma (MIU01/MIU30)
    #    'location'    => loan['library']['desc'], 
    #    'format'      => [item['item_data']['physical_material_type']['desc']], #get from item record
    #    'num'         => index, 
  
    #  }
    #end
  end

  private
 
end
