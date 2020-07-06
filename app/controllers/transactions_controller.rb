class TransactionsController < ApplicationController
  def index
    url ="users/#{params[:id]}/loans"
    loans = request_api(url)    
    transactions = loans['item_loan'].map.with_index do |loan, index|
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
    render json: transactions
  end

  def request_api(url)
    url = "#{ENV.fetch('ALMA_API_HOST')}/almaws/v1/#{url}"
    response = Excon.get(
      url,
      headers: {
        'Authorization' => "apikey #{ENV.fetch('ALMA_API_KEY')}",
        'accept' => 'application/json'
      }
    ) 
    JSON.parse(response.body)
  end
end
