=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
require 'spec_helper'

describe FlickrService do
  let(:flickr_service) { FlickrService.new }
  let(:pair_of_keys) {{'key' =>  'mock_key', 'secret' => 'mock_secret'}}

  it "get API key" do
    File.stub(:exists?).and_return(true)
    YAML.stub(:load_file).and_return(pair_of_keys)
    flickr_service.get_keys.should eq(pair_of_keys)
  end

  it "find_pictures" do
    FlickRaw.stub(:api_key)
    FlickRaw.stub(:shared_secret)
    FlickrService.any_instance.should_receive(:get_keys).and_return(pair_of_keys)
    FlickrService.any_instance.should_receive(:get_pictures).with('chicago').and_return(["some photo"])
    flickr_service.find_pictures("chicago").should eq ["some photo"]
  end
end
