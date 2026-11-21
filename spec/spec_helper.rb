require 'vcr'
require 'monetize'

VCR.configure do |c|
  c.default_cassette_options = { :record => :none }
  c.cassette_library_dir = 'spec/vcr'
  c.hook_into :webmock
end

WebMock.disable_net_connect!

Monetize.assume_from_symbol = true
