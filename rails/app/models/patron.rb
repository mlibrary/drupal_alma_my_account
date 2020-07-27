require './app/models/http_client'
require './app/models/response'
require 'date'

class Patron
  attr_reader :uniqname
  def initialize(uniqname:, client: HttpClient.new)
    @uniqname = uniqname
    @client = client
  end
  def list
    response = @client.get("/users/#{@uniqname}?user_id_type=all_unique&view=full&expand=none")
    if response.status == 200
      patron = JSON.parse(response.body)
      contact_info = ContactInfo.new(patron['contact_info'])
      Response.new(body:{   
         'uniqname' => patron['primary_id'], 
         'first_name' => patron['first_name'], #z303-name
         'last_name' => patron['last_name'], #z303-name
         'email' => contact_info.email, #z304-email
         'college' => nil, #Don't know #z303-home-library (and some other stuff?)
         'bor_status' => nil, #Don't know #z305-bor-status
         'booking_permission' => nil, #z305-booking-permission
         'campus' => patron['campus_code']['value'], #z303-profile-id
         'barcode' => nil, #z303-id (aleph id for user)
         'address_1' => contact_info.address_1, #z304-address-1
         'address_2' => contact_info.address_2, #z304-address-2
         'zip' => contact_info.zip, #z304-zip
         'phone' => contact_info.phone, #z304-telephone
         'expires' => format_date(patron['expiry_date']), #z305-expiry-date
      })
    else
      response
    end
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
