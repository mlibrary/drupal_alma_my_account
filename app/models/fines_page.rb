require './app/models/fines'

class FinesPage < Fines
  def list
    fines = @client.get(url)
    return [] if fines['total_record_count'] == 0
    charges = Array.new
    payments = Array.new
    fines['fee'].each do |fine|
      item = @client.get("/items?item_barcode=#{fine['barcode']['value']}")
      charges.push(element(main: fine, bib: item))
      fine['transaction']&.each do |transaction|
        payments.push({'transaction' => transaction['external_transaction_id'] })
      end
    end

    {
      'count' => fines['total_record_count'],
      'amount' => fines['total_sum'],
      'charges' => charges,
      'payments' => payments
    }
  end
  def element(main:, bib:)
    {
      'author' => bib['bib_data']['author'], #z13-author
      'barcode' => main['barcode']['value'], #z30-barcode
      'date' => format_date(main['creation_time']), #z31-date #not sure
      'fine' => main['balance'], #z31-net-sum
      'fine_description' => main['type']['desc'],  #z31-description
      'href' => main['link'], #??????? getAttribute('href')
      'id'=> bib['bib_data']['mms_id'],  #mms_id z30-doc-number
      'library' => main['owner']['desc'], #owner?? #z31-payment-target
      'payment_cataloger' => '', #z31-payment-cataloger
      'status'=> main['status']['desc'],  #z31-status
      'sub_library' => main['owner']['desc'], #owner?? #z31-sub-library
      'title' => main['title'], #z13-title 
      'type' => main['type']['value'], #type_code #z31-type
      'value' => "(#{main['balance']})", #z31-net-sum (with the parens)
    }
  end
end
