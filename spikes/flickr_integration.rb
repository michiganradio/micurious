=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
require 'flickrie'
require "awesome_print"

api_key = "<API_KEY HERE, get it from mingle card #139>"
Flickrie.api_key = api_key
# REMEMBER: USE SYMBOL AS THE EXTRAS KEY, or the API will not handle it correctly
query = {:text => "Chicago", :license=>"1,2,3,4,5,6",:extras=>['owner_name','date_upload'],:per_page=>100}
photos =  Flickrie.search_photos(query)
photo = photos.first
# original url
url = "http://farm#{photo.farm}.staticflickr.com/#{photo.server}/#{photo.id}_#{photo.secret}.jpg"
ap "image url: #{url}"
# attribution url
# webpage_url = "http://www.flickr.com/photos/#{photo.owner.id}/#{photo.id}"
ap "webpage url: #{photo.url}"
ap "title: #{photo.title}"
ap "owner name: #{photo.owner.username}"
ap "uploaded at: #{photo.uploaded_at}"
