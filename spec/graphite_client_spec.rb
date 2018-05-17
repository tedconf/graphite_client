require 'graphite_client'
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "GraphiteClient" do

  it "should create a socket and report data to it" do
    time = Time.now
    TCPSocket.should_receive(:new).with("host", 2003).and_return(socket = double(:closed? => false))
    socket.should_receive(:write).with("hello.world 10.5 #{time.to_i}\n")
    graphite = GraphiteClient.new("host")
    graphite.report("hello.world", 10.5, time)
  end

  it "should accept an alternate port number" do
    time = Time.now
    TCPSocket.should_receive(:new).with("host", 2023).and_return(socket = double(:closed? => false))
    socket.should_receive(:write).with("hello.world 10.5 #{time.to_i}\n")
    graphite = GraphiteClient.new("host:2023")
    graphite.report("hello.world", 10.5, time)
  end

  it "should reuse the same socket" do
    time = Time.now
    TCPSocket.should_receive(:new).once.with("host", 2003).and_return(socket = double(:closed? => false))
    socket.should_receive(:write).twice
    graphite = GraphiteClient.new("host")
    graphite.report("hello.world", 10.5, time)
    graphite.report("hello.world", 10, time)
  end

  it "should not reuse a socket that is closed" do
    time = Time.now
    TCPSocket.should_receive(:new).twice.with("host", 2003).and_return(socket = double(:closed? => false))
    socket.should_receive(:write)
    socket.should_receive(:write)
    graphite = GraphiteClient.new("host")
    graphite.report("hello.world", 10.5, time)
    socket.stub!(:closed? => true)
    graphite.report("hello.world", 10, time)
  end

  context "error handling" do

    it "should reset the socket on Errno::EPIPE" do
      time = Time.now
      TCPSocket.should_receive(:new).twice.with("host", 2003).and_return(socket = double(:closed? => false))
      socket.should_receive(:write).and_raise(Errno::EPIPE)
      socket.should_receive(:write)
      graphite = GraphiteClient.new("host")
      graphite.report("hello.world", 10.5, time)
      graphite.report("hello.world", 10, time)
    end

    it "should fail silently on Errno::EHOSTUNREACH" do
      TCPSocket.should_receive(:new).and_raise(Errno::EHOSTUNREACH)
      graphite = GraphiteClient.new("host")
      -> {
        graphite.report("hello.world", 10.5, Time.now)
      }.should_not raise_error
    end

    it "should fail silently on Errno::ECONNREFUSED" do
      TCPSocket.should_receive(:new).and_raise(Errno::ECONNREFUSED)
      graphite = GraphiteClient.new("host")
      -> {
        graphite.report("hello.world", 10.5, Time.now)
      }.should_not raise_error
    end

  end

  it "should be possible to force the socket close" do
    time = Time.now
    TCPSocket.should_receive(:new).twice.with("host", 2003).and_return(socket = double(:closed? => false))
    socket.should_receive(:write)
    socket.should_receive(:write)
    graphite = GraphiteClient.new("host")
    graphite.report("hello.world", 10.5, time)
    socket.should_receive(:close)
    graphite.close_socket
    graphite.report("hello.world", 10, time)
  end

end

