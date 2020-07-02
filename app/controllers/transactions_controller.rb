class TransactionsController < ApplicationController
  def index
    url ="users/#{params[:id]}/loans"
    loans = request_api(url)    
    transactions = loans['item_loan'].map  do |l|
      [
        'duedate' => l['due_date'],
        'isbn'    => '',
        'status'      => '',
        'author'  => l['author'],
        'title'   => l['title'],
        'barcode'   => l['item_barcode'],
        'call_number' => '', 
        'description' => '', 
        'id'          => '', 
        'bib_library' => '', 
        'location'    => '', 
        'format'      => '', 
        'num'         => '', 
  
      ]
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
