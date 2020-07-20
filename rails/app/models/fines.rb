class Fines
  attr_reader :uniqname
  def initialize(uniqname:, client: HttpClient.new)
    @uniqname = uniqname
    @client = client
    @raw = @client.get(url)
    @fines = get_fines
  end
  def url
    "/users/#{@uniqname}/fees"
  end
  def list
  end
  private
  def get_fines
    return nil if @raw['total_record_count'] == 0
    @raw['fee'].map do |fine|
      bib = @client.get("/items?item_barcode=#{fine['barcode']['value']}")
      { main: fine, bib: bib }
    end
  end
end
