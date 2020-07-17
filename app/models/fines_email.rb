require './app/models/fines'
require './app/models/email_fine'

class FinesEmail < Fines
  def list
    return [] if @fines.nil?
    @fines.map do |fine|
      EmailFine.new(fine).to_h 
    end
  end
end

