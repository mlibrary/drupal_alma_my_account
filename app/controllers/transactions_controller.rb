class TransactionsController < ApplicationController
  def index
    url ="#{ENV.fetch('ALMA_API_HOST')}/almaws/v1/users?apikey=#{ENV.fetch('ALMA_API_KEY')}" 
    users = request_api(url)    
    render json: users
  end

  def request_api(url)
    response = Excon.get(
      url,
      headers: {
        'accept' => 'application/json'
      }
    ) 
    JSON.parse(response.body)
  end
end
