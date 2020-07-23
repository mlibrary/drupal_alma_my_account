require './app/models/http_client'
require './app/models/loans'

class LoanRenewer
  attr_reader :client, :loans_class
  def initialize(client: HttpClient.new, loans_class: Loans)
    @client = client
    @loans_class = loans_class
  end
  def renew(uniqname:, barcode:)
    loans = loans_class.new(uniqname: uniqname).get
    loan = loans['item_loan'].find{ |x| x['item_barcode'].to_s == barcode.to_s}
    url = "/users/#{uniqname}/loans/#{loan['loan_id']}?op=renew"
    response =  @client.post(url)
    if response.status == 503
        "Not Renewed: Unable to renew item -- no response from server"
    else
      body = JSON.parse(response.body)
      if body["errorsExist"]
        "Not Renewed: #{body['errorList']['error'].first['errorMessage']}"
      else
        "Renewed: item renewed"
      end 
    end 
  end
end
