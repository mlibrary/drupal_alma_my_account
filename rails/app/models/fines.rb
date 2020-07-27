class Fines
  attr_reader :uniqname
  def initialize(uniqname:, client: HttpClientFull.new)
    @uniqname = uniqname
    @client = client
    @response = @client.get_all(url:url, record_name: 'fee')
    @body = JSON.parse(@response.body) 
    @fines = get_fines
  end
  def url
    "/users/#{@uniqname}/fees"
  end
  def list
  end
  private
  def get_fines
    return nil if @response.status != 200
    return nil if @body['total_record_count'] == 0
    @body['fee'].map do |fine|
      fine['barcode'] ? bib = get_bib(fine['barcode']['value']) : bib = {}
      { main: fine, bib: bib }
    end
  end

  def get_bib(barcode)
      resp = @client.get("/items?item_barcode=#{barcode}")
      if resp.status == 200
        JSON.parse(resp.body)
      else
        nil
      end
  end
end
