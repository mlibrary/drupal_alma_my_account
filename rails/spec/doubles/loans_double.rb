require './spec/doubles/excon_response_double'
class LoansDouble
  def initialize(uniqname:)
  end
  def get
    ExconResponseDouble.new(body: File.read('./spec/fixtures/loans.json'))
  end
end
