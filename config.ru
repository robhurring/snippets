require 'rubygems'
require 'snippets'

log = ::File.new('log/snip.log', 'a+')
STDERR.reopen(log)
STDOUT.reopen(log)

run Snippets