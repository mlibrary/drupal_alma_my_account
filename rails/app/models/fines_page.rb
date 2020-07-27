require './app/models/fines'
require './app/models/charge'
require './app/models/response'

class FinesPage < Fines
  def list
    return @response if @response.status != 200
    return Response.new(body:[]) if @fines.nil?

    charges = []
    payments = []
    @fines.each do |fine|
      unless fine[:main]['type']['value'] == "CREDIT"
        charges.push(Charge.new(fine).to_h)
        fine[:main]['transaction']&.each do |transaction|
          payments.push({'transaction' => transaction['external_transaction_id'] })
        end
      end
    end
    Response.new(body: 
      {
        'count' => charges.count,
        'amount' => @body['total_sum'],
        'charges' => charges,
        'payments' => payments
      }
    )
  end
end

