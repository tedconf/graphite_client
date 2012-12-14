# graphite_client #

## About ##

Very simple ruby client for reporting metrics to [Graphite](http://graphite.wikidot.com/).

Original code taken from a Gist created by [joakimk](https://github.com/joakimk).
https://gist.github.com/1678399


## Usage ##

Reporting the standard way, over TCP:

    graphite = GraphiteClient.new('graphite_host')
    graphite.report('metric name', value, time)
    graphite.report('another metric name', another_value, another_time)

Reporting [events](https://code.launchpad.net/~lucio.torre/graphite/add-events/+merge/69142):

    graphite_event = GraphiteClient::EventReport.new('http://graphite_host/events/')
    graphite_event.report({'what' => 'an event', 'tags' => 'some,tags', 'data' => 'info'})
