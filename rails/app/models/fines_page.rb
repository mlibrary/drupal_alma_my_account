require './app/models/fines'
require './app/models/charge'

class FinesPage < Fines
  def list
    return [] if @fines.nil?

    charges = []
    payments = []
    @fines.each do |fine|
      charges.push(Charge.new(fine).to_h)
      fine[:main]['transaction']&.each do |transaction|
        payments.push({'transaction' => transaction['external_transaction_id'] })
      end
    end
    
    {
      'count' => @raw['total_record_count'],
      'amount' => @raw['total_sum'],
      'charges' => charges,
      'payments' => payments
    }
  end
end

