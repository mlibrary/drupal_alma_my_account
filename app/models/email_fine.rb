require './app/models/fine'
class EmailFine < Fine
  def to_h
    {
      'barcode'     => @barcode,
      'call_number' => @call_number,
      'date'        => @date,
      'description' => @description,
      'fine'        => @fine,
      'fine_description' => @fine_description,
      'id'          => @mms_id,
      'library'     => @library, 
      'location'    => @item_location, 
      'payment_cataloger' => @payment_cataloger,
      'status'      => @status,
      'sub_library' => @sub_library, #z31-sublibrary
      'target'      => @target, #z31-payment-target or z31-sub-library
      'title'       => @title, #z13-title
      'type'        => @type, #z31-type
    } 
  end
end
