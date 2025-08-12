require 'fiddle'
Fiddle.const_set(:VERSION, '0.0.0') unless Fiddle.const_defined?(:VERSION)
require 'rails'
require File.expand_path('../boot', __FILE__)
all_environments = [
  :development,
  :production,
  :test
]