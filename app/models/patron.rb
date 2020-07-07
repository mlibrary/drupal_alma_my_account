require './app/models/requester'
require 'date'

class Patron
  attr_reader :uniqname
  def initialize(uniqname:, requester: Requester.new)
    @uniqname = uniqname
    @requester = requester
  end
  def list
    patron = @requester.request("users/#{@uniqname}?user_id_type=all_unique&view=full&expand=none")
    contact_info = ContactInfo.new(patron['contact_info'])
   { 
         'uniqname' => patron['primary_id'],
         'first_name' => patron['first_name'],
         'last_name' => patron['last_name'],
         'email' => contact_info.email,
         'college' => nil, #Don't know
         'bor_status' => nil, #Don't know
         'booking_permission' => nil, #Don't know
         'campus' => patron['campus_code']['value'],
         'barcode' => nil, #Don't know
         'address_1' => contact_info.address_1,
         'address_2' => contact_info.address_2,
         'zip' => contact_info.zip,
         'phone' => contact_info.phone,
         'expires' => format_date(patron['expiry_date']),
    }
  end

  private

  def format_date(date)
    date ? DateTime.parse(date).strftime('%Y%m%d') : ''
  end
end

class ContactInfo
  
  def initialize(contact)
    @contact = contact
  end

  def email
    preferred = @contact['email'].find{|i| i['preferred'].to_s == 'true' }
    preferred ? preferred['email_address'] : ''
  end

  def address_1
    address['line1']
  end 
  def address_2
    address['line2']
  end 

  def zip
    address['postal_code']
  end

  def phone
    preferred = @contact['phone'].find{|i| i['preferred'].to_s == 'true' }
    preferred ? preferred['phone_number'] : ''
  end

  private
  def address
    @contact['address'].find{|i| i['preferred'].to_s == 'true' }
  end
end
