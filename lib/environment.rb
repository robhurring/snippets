$: << File.dirname(__FILE__)

require 'sinatra/base'
require 'rack-flash'
require 'rack/google_analytics'

require 'core_ext'
require 'helpers'
require 'models'
require 'diff'
require 'highlighter'