require './app/models/http_client'
require './app/models/loans'

class LoanRenewer
  attr_reader :client, :loans_class
  def initialize(uniqname:, client: HttpClient.new, loans_class: Loans)
    @client = client
    @loans_class = loans_class
    @uniqname = uniqname
    @loans = @loans_class.new(uniqname: @uniqname)
  end
  def renew(barcode:)
    return Response.new(body: "Not Renewed", status: @loans.response.status) if @loans.response.status != 200
    loan = @loans.records.find{ |x| x[:main]['item_barcode'].to_s == barcode.to_s}[:main]
    url = "/users/#{@uniqname}/loans/#{loan['loan_id']}?op=renew"
    response =  @client.post(url)
    case response.status
    when 503
      Response.new(body: "Not Renewed: Unable to renew item -- no response from server", status: 503)
    when 200
      Response.new(body:"Renewed: item renewed")
    else
      body = JSON.parse(response.body)
      Response.new(body: "Not Renewed: #{body['errorList']['error'].first['errorMessage']}", status: response.status)
    end
  end
end
