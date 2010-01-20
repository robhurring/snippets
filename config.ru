require 'rubygems'
require 'snippets'

log = ::File.new('log/snippets.log', 'a+')
STDERR.reopen(log)
STDOUT.reopen(log)

run Snippets