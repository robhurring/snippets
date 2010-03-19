$: << File.dirname(__FILE__)

require 'rubygems'
require 'sinatra/base'
require 'rack-flash'

require 'core_ext'
require 'helpers'
require 'models'
require 'diff'
require 'highlighter'
require 'caching'