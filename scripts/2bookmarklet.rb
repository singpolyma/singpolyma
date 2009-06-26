#!/usr/bin/ruby

require 'cgi'

script = STDIN.read
script.gsub!(/(^\s*|;\s*)\/\/.+$/,'')
script.gsub!(/^\s*$(\r?\n)?/,'')
script.gsub!(/ +/,'--THISISWHITESPACE--')
script = CGI::escape(script);
script.gsub!(/--THISISWHITESPACE--/, '%20')

puts "javascript:(function(){#{script}})();"
