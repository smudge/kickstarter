require 'vcr'
require 'money'

VCR.configure do |c|
  c.default_cassette_options = { :record => :new_episodes }
  c.cassette_library_dir = 'spec/vcr'
  c.hook_into :webmock
end

Money.assume_from_symbol = true