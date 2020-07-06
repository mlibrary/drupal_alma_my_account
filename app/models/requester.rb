class Requester
  def request(url)
    url = "#{ENV.fetch('ALMA_API_HOST')}/almaws/v1/#{url}"
    response = Excon.get(
      url,
      headers: {
        'Authorization' => "apikey #{ENV.fetch('ALMA_API_KEY')}",
        'accept' => 'application/json'
      }
    ) 
    JSON.parse(response.body)
  end
end
