# graphite_client #

## About ##

Very simple ruby client for reporting metrics to [Graphite](http://graphite.wikidot.com/).

[Original code](https://gist.github.com/1678399) taken from a Gist by [joakimk](https://github.com/joakimk/).

## Usage ##

### Reporting the standard way, over TCP ###

    graphite = GraphiteClient.new('graphite_host')
    graphite.report('metric name', value, time)
    graphite.report('another metric name', another_value, another_time)

### Reporting [events](https://code.launchpad.net/~lucio.torre/graphite/add-events/+merge/69142) ###

    graphite_event = GraphiteClient::EventReporter.new('http://graphite_host/events/')
    graphite_event.report('what' => 'an event', 'tags' => 'some,tags', 'data' => 'some info')

* When reporting an event, you can (optionally) pass `:basic_auth => { :username => 'un', :password => 'pw' }` to the `GraphiteClient::EventReporter` constructor.
