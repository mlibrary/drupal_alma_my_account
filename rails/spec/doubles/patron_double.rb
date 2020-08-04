require './spec/doubles/excon_response_double'
require 'json'
class PatronDouble
  attr_reader :uniqname
  def initialize(uniqname:,response: '{}')
    @response = response
    @uniqname = uniqname
  end
  def response
    ExconResponseDouble.new(body: @response)
  end
  def body
    JSON.parse(@response)
  end
end
