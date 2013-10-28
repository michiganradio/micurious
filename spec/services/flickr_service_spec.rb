require 'spec_helper'

describe FlickrService do
  let(:flickr_service) { FlickrService.new }

  it "get API key" do
    File.stub(:exists?).and_return(true)
    YAML.stub(:load_file).and_return({"key"=>"mock_key"})
    flickr_service.get_api_key.should eq "mock_key"
  end

  it "find_pictures" do
    File.stub(:exists?).and_return(true)
    YAML.stub(:load_file).and_return({"key"=>"mock_key"})
    Flickrie.stub(:search_photos).and_return("some photo")
    flickr_service.find_pictures("chicago").should eq "some photo"
  end
end
