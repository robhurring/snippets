require 'snippets'

log = ::File.new('log/snippets.log', 'a+')
$stderr.reopen(log)
$stdout.reopen(log)

run Snippets