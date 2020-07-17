require './app/models/fines'
require './app/models/fine'

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

class  Charge < Fine
  def to_h
    {
      'author' => @author,
      'barcode' => @barcode,
      'date' => @date,
      'fine' => @fine,
      'fine_description' => @fine_description,
      'href' => @link, #??????? getAttribute('href')
      'id'=> @mms_id,  #mms_id z30-doc-number
      'library' => @library, #owner?? #z31-payment-target
      'payment_cataloger' => @payment_cataloger, #z31-payment-cataloger
      'status'=> @status,  #z31-status
      'sub_library' => @sub_library, #owner?? #z31-sub-library
      'title' => @title, #z13-title 
      'type' => @type, #type_code #z31-type
      'value' => "(#{@fine})", #z31-net-sum (with the parens)
    }
  end
end
