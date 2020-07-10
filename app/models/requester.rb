class Requester
  def request(url)
    url.slice!('/almaws/v1') #for barcode locations
    url = "#{ENV.fetch('ALMA_API_HOST')}/almaws/v1#{url}"
    response = excon_get(url)
    case response.status
    when 200
      JSON.parse(response.body)
    when 302
      Requester.new.request(response.headers['Location'])
    end
  end
  private
  def excon_get(url)
    Excon.get(
      url,
      headers: {
        'Authorization' => "apikey #{ENV.fetch('ALMA_API_KEY')}",
        'accept' => 'application/json'
      }
    ) 
  end
end
