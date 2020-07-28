class ExconResponseDouble
  attr_reader :status, :body
  def initialize(status: 200, body:'{}')
    @body = body
    @status = status
  end
end
