require './app/models/fines'
require './app/models/email_fine'

class FinesEmail < Fines
  def list
    return [] if @fines.nil?
    output =  @fines.map do |fine|
      EmailFine.new(fine).to_h unless(fine[:main]['type']['value'] == 'CREDIT')
    end
    output[0].nil? ? [] : output
  end
    
end

