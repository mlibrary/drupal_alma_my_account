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
    @client.post(url)
  end
end
