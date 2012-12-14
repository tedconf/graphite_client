require 'json'
require 'net/http'
require 'net/https'

class GraphiteClient
  class EventReporter
    def initialize(graphite_server_events_url, opts={})
      uri   = URI(graphite_server_events_url)
      @http = Net::HTTP.new(uri.host, uri.port)
      @req  = Net::HTTP::Post.new(uri.request_uri)

      @http.use_ssl = true if uri.scheme == 'https'

      if opts[:basic_auth]
        username = opts[:basic_auth][:username]
        password = opts[:basic_auth][:password]
        @req.basic_auth(username, password)
      end
    end

    def report(event)
      @req.body = EventValue.from(event)
      @http.request(@req)
    end

    class EventValue
      def self.from(event={})
        event[:tags] = Array(event[:tags]).join(',')
        event.to_json
      end
    end
  end
end
