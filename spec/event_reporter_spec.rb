require 'graphite_client'
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "GraphiteClient::EventReporter" do
  before do
    @url         = 'http://example.com/path'
    @uri         = URI(@url)
    @https_url   = 'https://example.com/path'
    @https_uri   = URI(@https_url)
    @event       = {:what => 'test', :tags => 'test', :data => 'test'}
    @basic_auth  = {:username => 'test', :password => 'test'}
  end

  it "should create an HTTP connection and POST to it" do
    Net::HTTP.should_receive(:new).with(@uri.host, @uri.port).and_return(http = mock())
    Net::HTTP::Post.should_receive(:new).with(@uri.request_uri).and_return(req = mock())
    req.should_receive(:body=).with(@event.to_json)
    http.should_receive(:request).with(req)
    event_reporter = GraphiteClient::EventReporter.new(@url)
    event_reporter.report(@event)
  end

  it "should reuse the same HTTP connection" do
    Net::HTTP.should_receive(:new).with(@uri.host, @uri.port).and_return(http = mock())
    Net::HTTP::Post.should_receive(:new).with(@uri.request_uri).and_return(req = mock())
    req.should_receive(:body=).twice.with(@event.to_json)
    http.should_receive(:request).twice.with(req)
    event_reporter = GraphiteClient::EventReporter.new(@url)
    event_reporter.report(@event)
    event_reporter.report(@event)
  end

  it "should encode a non-string data element as json" do
    Net::HTTP.should_receive(:new).with(@uri.host, @uri.port).and_return(http = mock())
    Net::HTTP::Post.should_receive(:new).with(@uri.request_uri).and_return(req = mock())

    event = {
      :what => 'test',
      :tags => 'test',
      :data => {:some => 'a', :useful => 'b', :data => 'c'}
    }

    expected = {}
    expected[:what] = event[:what]
    expected[:tags] = event[:tags]
    expected[:data] = event[:data].to_json

    req.should_receive(:body=).with(expected.to_json)
    http.should_receive(:request).with(req)
    event_reporter = GraphiteClient::EventReporter.new(@url)
    event_reporter.report(event)
  end

  context "with basic auth" do
    it "should create an HTTP connection and POST to it, using basic auth" do
      Net::HTTP.should_receive(:new).with(@uri.host, @uri.port).and_return(http = mock())
      Net::HTTP::Post.should_receive(:new).with(@uri.request_uri).and_return(req = mock())
      req.should_receive(:basic_auth).with(@basic_auth[:username], @basic_auth[:password])
      req.should_receive(:body=).with(@event.to_json)
      http.should_receive(:request).with(req)
      event_reporter = GraphiteClient::EventReporter.new(@url, basic_auth: @basic_auth)
      event_reporter.report(@event)
    end
  end

  context "over SSL" do
    it "should create an HTTPS connection and POST to it" do
      Net::HTTP.should_receive(:new).with(@https_uri.host, @https_uri.port).and_return(http = mock())
      Net::HTTP::Post.should_receive(:new).with(@https_uri.request_uri).and_return(req = mock())
      http.should_receive(:use_ssl=).with(true)
      req.should_receive(:body=).with(@event.to_json)
      http.should_receive(:request).with(req)
      event_reporter = GraphiteClient::EventReporter.new(@https_url)
      event_reporter.report(@event)
    end

    it "should create an HTTPS connection and POST to it, using basic auth" do
      Net::HTTP.should_receive(:new).with(@https_uri.host, @https_uri.port).and_return(http = mock())
      Net::HTTP::Post.should_receive(:new).with(@https_uri.request_uri).and_return(req = mock())
      http.should_receive(:use_ssl=).with(true)
      req.should_receive(:basic_auth).with(@basic_auth[:username], @basic_auth[:password])
      req.should_receive(:body=).with(@event.to_json)
      http.should_receive(:request).with(req)
      event_reporter = GraphiteClient::EventReporter.new(@https_url, basic_auth: @basic_auth)
      event_reporter.report(@event)
    end
  end
end
