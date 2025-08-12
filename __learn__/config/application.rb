require 'fiddle'
Fiddle.const_set(:VERSION, '0.0.0') unless Fiddle.const_defined?(:VERSION)
require 'rails'
require File.expand_path('../boot', __FILE__)
all_environments = [
  :development,
  :production,
  :test
]
Bundler.require(
  *Rails.groups(
    coverage: [:test],
    db: all_environments,
    pcap: all_environments
  )
)
# Railties
# For compatibility with jquery-rails (and other engines that require action_view) in pro
require 'action_controller/railtie'
require 'action_view/railtie'