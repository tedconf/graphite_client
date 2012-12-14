require 'net/http'
require 'json'

class GraphiteClient
  class EventReporter
    def initialize(graphite_server_events_url, opts={})
      uri   = URI(graphite_server_events_url)
      @http = Net::HTTP.new(uri.host, uri.port)
      @req  = Net::HTTP::Post.new(uri.request_uri)

      if opts[:basic_auth]
        username = opts[:basic_auth][:username]
        password = opts[:basic_auth][:password]
        @req.basic_auth(username, password)
      end
    end

    def report(event={})
      @req.body = event.to_json
      @http.request(@req)
    end
  end
end
