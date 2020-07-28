require './spec/doubles/excon_response_double'
require 'json'
class LoansDouble
  def initialize(uniqname:)
  end
  def response
    ExconResponseDouble.new(body: File.read('./spec/fixtures/loans.json'))
  end
  def get
    ExconResponseDouble.new(body: File.read('./spec/fixtures/loans.json'))
  end
  def records
    loans = JSON.parse(File.read('./spec/fixtures/loans.json'))['item_loan']
    [
      { main: loans[0], bib: JSON.parse(File.read('./spec/fixtures/basics_of_singing_item.json')) },
      { main: loans[1], bib: JSON.parse(File.read('./spec/fixtures/plain_words_on_singing_item.json')) },

    ]
  end
end
