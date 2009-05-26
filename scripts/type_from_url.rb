#!/usr/bin/ruby

# Extract links based on type from a URL
# ruby type_from_url.rb application/pgp-keys http://singpolyma.net/

require 'open-uri'
require 'hpricot'
require 'uri'

uri_arg = URI::parse(ARGV[1])
doc = Hpricot.parse(open(ARGV[1]).read)
doc.search("//a[@type='#{ARGV[0]}'] || //link[@type='#{ARGV[0]}']") do |el|
	uri = URI::parse(el.attributes['href'])
	if uri.host.to_s == '' && el.attributes['href'][0..0] != '/'
		uri.path = uri_arg.path.to_s + uri.path.to_s
	end
	uri.scheme = uri_arg.scheme if uri.scheme.to_s == ''
	uri.host = uri_arg.host if uri.host.to_s == ''
	uri.port = uri_arg.port if uri.port.to_s == '' && uri.scheme != 'http'
	puts uri
end
