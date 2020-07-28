require './app/models/fines'
require './app/models/email_fine'
require './app/models/response'

class FinesEmail < Fines
  def list
    return @response if @response.status != 200
    output =  @records.map do |fine|
      EmailFine.new(fine).to_h unless(fine[:main]['type']['value'] == 'CREDIT')
    end
    output[0].nil? ? Response.new(body: []) : Response.new(body: output)
  end
    
end

