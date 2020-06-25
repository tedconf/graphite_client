source "https://rubygems.org"
# Add dependencies required to use your gem here.
# Example:
#   gem "activesupport", ">= 2.3.5"

# Add dependencies to develop your gem here.
# Include everything needed to run rake, tests, features, etc.
group :development do
  # https://stackoverflow.com/a/35893625
  gem 'rake', '< 13.0'
  # Cannot use 3.x, due to failing socket.stub test in graphite_client_spec.rb
  gem "rspec", "~> 3.9.0"
  gem "rdoc", "~> 6.0.4"
  gem "bundler", "~> 1.16.1"
  gem "jeweler", "~> 2.3.9"
end

# For jenkins
gem 'rubocop'
gem 'rubocop-checkstyle_formatter'
gem 'bundle-audit'
