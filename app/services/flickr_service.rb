require 'flickrie'

class FlickrService
  def get_api_key
    if File.exists? 'config/api-key.yml'
      config = YAML.load_file('config/api-key.yml')
      return config["key"]
    end
    return "some key"
  end

  def find_pictures(search_string)
    Flickrie.api_key = get_api_key
    query = {:text => search_string, :license=>"1,2,3,4,5,6", :extras=>['owner_name'], :per_page=>50}
    Flickrie.search_photos(query).map{|photo| FlickrPicture.new(photo)}
  end
end
