# graphite_client #

# How is this used at TED

The following apps use this Gem

* page_builder
* ted_ed_upload
* videometrics_mysql
* identity.ted.com
* dam_upload

# ARG!!!
This gem is really old and is using Jewler to package it self. This method fell
out of favor in the community. This app really should use the built in bundler
ways to package a gem. As such this gem isn't on the TED Private gemserver .


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
    graphite_event.report(:what => 'an event', :tags => ['some', 'tags'], :data => 'some info')

* When reporting an event, you can (optionally) pass `:basic_auth => { :username => 'un', :password => 'pw' }` to the `GraphiteClient::EventReporter` constructor.


  <!--- project_def -->
  Very simple ruby client for reporting metrics to Graphite.

    - Intended subjects: howtos, high-level documentation & guides, etc.
    - Intended audience: TED Tech staff.
    - Vertical: Operations
    - Related Links:
      - https://github.com/tedconf/graphite_client
  <!--- /project_def -->
