# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "graphite_client"
  s.version = "0.4.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alex Dean", "Matthew Trost"]
  s.date = "2012-12-19"
  s.description = "Original code by https://github.com/joakimk."
  s.email = "alex@crackpot.org"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".document",
    ".rspec",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "graphite_client.gemspec",
    "lib/graphite_client.rb",
    "lib/graphite_client/event_reporter.rb",
    "spec/event_reporter_spec.rb",
    "spec/graphite_client_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = "http://github.com/tedconf/graphite_client"
  s.licenses = ["MIT"]
  s.require_paths = ["lib", "lib/graphite_client"]
  s.rubygems_version = "1.8.24"
  s.summary = "Very simple ruby client for graphite."

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.ted.com/private"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      # https://stackoverflow.com/a/35893625
      s.add_development_dependency(%q<rake>, "< 14.0")
      #
      s.add_development_dependency(%q<rspec>, ["~> 2.99.0"])
      s.add_development_dependency(%q<rdoc>, ["~> 6.0.4"])
      s.add_development_dependency(%q<bundler>, ["~> 1.16.1"])
      s.add_development_dependency(%q<jeweler>, ["~> 2.3.9"])
    else
      s.add_dependency(%q<rspec>, ["~> 2.11.0"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, ["~> 1.2.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
    end
  else
    s.add_dependency(%q<rspec>, ["~> 2.11.0"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, ["~> 1.2.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
  end
end

