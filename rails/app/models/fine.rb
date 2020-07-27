require 'date'
class Fine
  def initialize(main:, bib:)
      @bib = bib
      
      @author = bib_output(['bib_data','author']) #z13-author
      @barcode = main['barcode']['value'] #z30-barcode
      @call_number = bib_output(['holding_data','call_number']) #z30-call-number
      @date = format_date(main['creation_time']) #z31-date #not sure
      @description = '' #z30-description
      @fine = main['balance'] #z31-net-sum
      @fine_description = main['type']['desc']  #z31-description
      @item_location = bib_output(['item_data','library','desc']) #z30-sub-library
      @library = main['owner']['desc']  #z31-payment-target 
      @link = main['link']
      @mms_id = bib_output(['bib_data','mms_id'])  #mms_id
      @payment_cataloger = ''  #z31-payment-cataloger
      @status = main['status']['desc'] #z31-status
      @sub_library = main['owner']['desc'] #z31-sublibrary
      @target = main['owner']['desc'] #z31-payment-target or z31-sub-library
      @title = main['title'] #z13-title
      @type = main['type']['value'] #z31-type
  end
  def format_date(date)
    DateTime.parse(date).strftime("%Y%m%d")
  end

  def to_h
    {}
  end
  private 
  def bib_output(keys)
    if @bib
      @bib.dig(*keys)
    else
      ''
    end
  end
end
