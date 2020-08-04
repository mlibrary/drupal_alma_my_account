require './app/models/http_client'
class SmsChanger
  attr_reader :patron
  def initialize(patron:,client: HttpClient.new)
    @patron = patron
    @client = client
    @body = patron.body
  end
  def set(phone)
    @body["contact_info"]["phone"].push(phone_entry(phone))
    @client.put(url, @body.to_json)  
  end
  def unset
  end

  private
  def url
    "/users/#{@patron.uniqname}?user_id_type=all_unique&send_pin_number_letter=false&recalculate_roles=false"
  end
  def phone_entry(phone)
    {
      "preferred" => "true",
      "preferred_sms" => "true",
      "segment_type"=> "Internal",
      "phone_number" => phone,
      "phone_type" => [ {"value" => "mobile"} ],
    }
  end
end
