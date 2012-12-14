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

    def report(event={})
      event[:tags] = Array(event[:tags]).join(',')
      @req.body = event.to_json
      @http.request(@req)
    end
  end
end
