require 'graphite_client'
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'json'

describe "GraphiteClient::EventReporter::EventValue" do
  before do
    @event_value_class = GraphiteClient::EventReporter::EventValue
  end

  it "should accept a Hash and return JSON" do
    JSON.parse(@event_value_class.from({:what => 'test', :tags => 'test', :data => 'test'})).should be_a(Hash)
  end

  it "leaves a :tags String as a single value" do
    event_hash = JSON.parse(@event_value_class.from({ :what => 'test', :tags => 'testStr1,testStr2', :data => 'test'}))
    event_hash['tags'].should eq('testStr1,testStr2')
  end

  it "converts a :tags Array into CSVs" do
    event_hash = JSON.parse(@event_value_class.from({ :what => 'test', :tags => ['test1', 'test2'], :data => 'test'}))
    event_hash['tags'].should eq('test1,test2')
  end
end
