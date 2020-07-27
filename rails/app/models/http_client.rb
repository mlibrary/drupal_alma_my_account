class HttpClient
  def initialize()
    @headers = {
        'Authorization' => "apikey #{ENV.fetch('ALMA_API_KEY')}",
        'accept' => 'application/json'
      }
  end

  def get(url)
    response = Excon.get( full_url(url), headers: @headers ) 
    case response.status
    when 200
      response
    when 302
      HttpClient.new.get(response.headers['Location'])
    else
      response
    end
  end

  def post(url)
    Excon.post( full_url(url), headers: @headers )
  end

  def delete(url)
    Excon.delete( full_url(url), headers: @headers )
  end
  private
  def full_url(url)
    url.slice!('/almaws/v1') #for barcode locations
    "#{ENV.fetch('ALMA_API_HOST')}/almaws/v1#{url}"
  end
end
