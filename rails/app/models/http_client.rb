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
      JSON.parse(response.body)
    when 302
      HttpClient.new.get(response.headers['Location'])
    end
  end

  def put(url)
    response = Excon.put( full_url(url), headers: @headers )
    JSON.parse(response.body)
  end
  def post(url)
    response = Excon.post( full_url(url), headers: @headers )
    JSON.parse(response.body)
  end

  def delete(url)
    response = Excon.delete( full_url(url), headers: @headers )
    response.data.to_json
  end
  private
  def full_url(url)
    url.slice!('/almaws/v1') #for barcode locations
    "#{ENV.fetch('ALMA_API_HOST')}/almaws/v1#{url}"
  end
end
