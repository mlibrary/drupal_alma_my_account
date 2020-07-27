class Response
  attr_reader :status, :body
  def initialize(body: {}, status: 200)
    @body = body
    @status = status
  end
end
