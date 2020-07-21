class LoansDouble
  def initialize(uniqname:)
  end
  def get
    JSON.parse(File.read('./spec/fixtures/loans.json'))  
  end
end
