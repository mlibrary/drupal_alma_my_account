class Fines
  attr_reader :uniqname
  def initialize(uniqname:, client: HttpClientFull.new)
    @uniqname = uniqname
    @client = client
    @raw = @client.get_all(url:url, record_name: 'fee')
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
      bib = @client.get("/items?item_barcode=#{fine['barcode']['value']}") if fine['barcode']
      { main: fine, bib: bib }
    end
  end
end
