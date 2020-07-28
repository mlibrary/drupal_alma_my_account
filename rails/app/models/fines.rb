require './app/models/records_with_bib'

class Fines < RecordsWithBib
  def url
    "/users/#{@uniqname}/fees"
  end
  def record_key
    'fee'
  end

  def barcode_key
    ['barcode','value'] 
  end

  def list
  end

end
