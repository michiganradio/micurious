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
