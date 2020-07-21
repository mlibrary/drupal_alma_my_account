require './app/models/http_client'
require 'date'

class History
  attr_reader :uniqname
  def initialize(uniqname:, client: HttpClient.new)
    @uniqname = uniqname
    @client = client
  end

  def list
    
    [
    { 
      'title' => '', #'z13/z13-title',
      'id' => '', #'z30/z30-doc-number',
      'barcode' => '', #'z30/z30-barcode',
      'date'  => '', #'z13/z13-year',
      'location' => '', #'z36h/z36h-sub-library',
      'collection' => '', #'z30/z30-collection',
      'call_number' => '', #'z30/z30-call-no',
      'returned_date' => '', #'z36h/z36h-returned-date',
      'loan_date' => '', #'z36h/z36h-loan-date',
      'isbn_issn_code' => '', #'z13/z13-isbn-issn-code',
      'isbn_issn' => '', #'z13/z13-isbn-issn',
      'description' => '', #'z30/z30-description',
      'hol_doc_number' => '', #'z30/z30-hol-doc-number',
      'item_status_code' => '', #'z30-item-status-code',
      'supress_link' => ''
    }.merge(no)  
    ]
  end

  private
  def no
   [
      'fine_description',
      'fine',
      'pickup_loc',
      '#duedate',
      'urgency',
      'booking_start',
      'booking_end',
      'created',
      'expires',
      'tags',
      'pickup_loc',
      'Holdings',
      'duedate',
      'status',
      'message',
      'date',
  ].map{|x| [x,nil]}.to_h
  end
end
