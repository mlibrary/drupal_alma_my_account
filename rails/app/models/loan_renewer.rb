require './app/models/http_client'
require './app/models/loans'

class LoanRenewer
  attr_reader :client, :loans_class
  def initialize(client: HttpClient.new, loans_class: Loans)
    @client = client
    @loans_class = loans_class
  end
  def renew(uniqname:, barcode:)
    loans_response = loans_class.new(uniqname: uniqname).get
    if loans_response.status == 200
      loans = JSON.parse(loans_response.body)
      loan = loans['item_loan'].find{ |x| x['item_barcode'].to_s == barcode.to_s}
      url = "/users/#{uniqname}/loans/#{loan['loan_id']}?op=renew"
      response =  @client.post(url)
      if response.status == 503
          Response.new(body: "Not Renewed: Unable to renew item -- no response from server", status: 503)
      else
        body = JSON.parse(response.body)
        if body["errorsExist"]
          Response.new(body: "Not Renewed: #{body['errorList']['error'].first['errorMessage']}", status: response.status)
        else
          Response.new(body:"Renewed: item renewed")
        end 
      end 
    else
      Response.new(body: "Not Renewed", status: loans_response.status)
    end
  end
end
