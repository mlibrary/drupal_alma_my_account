require './app/models/records'
class RecordsWithBib < Records
  def barcode_key
  end
  private
  def fetch
    @body[record_key].map do |record|
      record.dig(*barcode_key) ? bib = get_bib(record.dig(*barcode_key)) : bib = {}
      {main: record, bib: bib} 
    end
  end

  def get_bib(barcode)
    resp = @client.get("/items?item_barcode=#{barcode}")
    if resp.status == 200
      JSON.parse(resp.body)
    else
      {}
    end
  end
end
