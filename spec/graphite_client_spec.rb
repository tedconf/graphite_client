require 'graphite_client'
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "GraphiteClient" do

  it "should create a socket and report data to it" do
    time = Time.now
    expect(TCPSocket).to receive(:new).with("host", 2003)
                           .and_return(socket = instance_double('TCPSocket', :closed? => false))
    expect(socket).to receive(:write).with("hello.world 10.5 #{time.to_i}\n")
    graphite = GraphiteClient.new("host")
    graphite.report("hello.world", 10.5, time)
  end

  it "should accept an alternate port number" do
    time = Time.now
    expect(TCPSocket).to receive(:new).with("host", 2023)
                           .and_return(socket = instance_double('TCPSocket', :closed? => false))
    expect(socket).to receive(:write).with("hello.world 10.5 #{time.to_i}\n")
    graphite = GraphiteClient.new("host:2023")
    graphite.report("hello.world", 10.5, time)
  end

  it "should reuse the same socket" do
    time = Time.now
    expect(TCPSocket).to receive(:new).once
                           .with("host", 2003)
                           .and_return(socket = instance_double('TCPSocket', :closed? => false))
    expect(socket).to receive(:write).twice
    graphite = GraphiteClient.new("host")
    graphite.report("hello.world", 10.5, time)
    graphite.report("hello.world", 10, time)
  end

  it "should not reuse a socket that is closed" do
    time = Time.now
    expect(TCPSocket).to receive(:new).twice
                           .with("host", 2003)
                           .and_return(socket = instance_double('TCPSocket', :closed? => false))
    expect(socket).to receive(:write)
    expect(socket).to receive(:write)
    graphite = GraphiteClient.new("host")
    graphite.report("hello.world", 10.5, time)
    allow(socket).to receive(:closed?).and_return(true)
    graphite.report("hello.world", 10, time)
  end

  context "error handling" do

    it "should reset the socket on Errno::EPIPE" do
      time = Time.now
      expect(TCPSocket).to receive(:new).twice
                             .with("host", 2003)
                             .and_return(socket = instance_double('TCPSocket', :closed? => false))
      expect(socket).to receive(:write).and_raise(Errno::EPIPE)
      expect(socket).to receive(:write)
      graphite = GraphiteClient.new("host")
      graphite.report("hello.world", 10.5, time)
      graphite.report("hello.world", 10, time)
    end

    it "should fail silently on Errno::EHOSTUNREACH" do
      expect(TCPSocket).to receive(:new).and_raise(Errno::EHOSTUNREACH)
      graphite = GraphiteClient.new("host")
      expect(-> {
                graphite.report("hello.world", 10.5, Time.now)
              }).to_not raise_error
    end

    it "should fail silently on Errno::ECONNREFUSED" do
      expect(TCPSocket).to receive(:new).and_raise(Errno::ECONNREFUSED)
      graphite = GraphiteClient.new("host")
      expect(-> {
                graphite.report("hello.world", 10.5, Time.now)
              }).to_not raise_error
    end

  end

  it "should be possible to force the socket close" do
    time = Time.now
    expect(TCPSocket).to receive(:new).twice
                           .with("host", 2003)
                           .and_return(socket = instance_double('TCPSocket', :closed? => false))
    expect(socket).to receive(:write)
    expect(socket).to receive(:write)
    graphite = GraphiteClient.new("host")
    graphite.report("hello.world", 10.5, time)
    expect(socket).to receive(:close)
    graphite.close_socket
    graphite.report("hello.world", 10, time)
  end

end
