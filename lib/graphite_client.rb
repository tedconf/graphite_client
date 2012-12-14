require 'socket'

class GraphiteClient
  # "host" or "host:port"
  def initialize(host)
    @host, @port = host.split ':'
    @port = 2003 if ! @port
    @port = @port.to_i
  end

  def socket
    return @socket if @socket && !@socket.closed?
    @socket = TCPSocket.new(@host, @port)
  end

  def report(key, value, time = Time.now)
    begin
      socket.write("#{key} #{value.to_f} #{time.to_i}\n")
    rescue Errno::EPIPE, Errno::EHOSTUNREACH, Errno::ECONNREFUSED
      @socket = nil
      nil
    end
  end

  def close_socket
    @socket.close if @socket
    @socket = nil
  end
end

require 'graphite_client/event_reporter'
