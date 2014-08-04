=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
require 'flickraw'

class FlickrService
  def get_keys
    if File.exists? 'config/api-key.yml'
      config = YAML.load_file('config/api-key.yml')
      return { 'key' => config['key'], 'secret' => config['secret'] }
    end
    { 'key' => "some key", 'secret' => 'secret' }
  end

  def find_pictures(search_string)
    keys = get_keys
    FlickRaw.api_key = keys['key']
    FlickRaw.shared_secret = keys['secret']
    get_pictures(search_string)
  end

  def get_pictures(search_string)
    query = {:text => search_string, :license=>"1,2,3,4,5,6", :extras=>['owner_name'], :per_page=>50}
    x = flickr.photos.search(query).map{|photo| FlickrPicture.new(photo)}
    x
  end
end
