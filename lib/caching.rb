require 'fileutils'
require 'pathname'

module Caching

  def self.included(base)
    base.disable :caching
    base.set :cache_output_dir, ''
    base.set :cache_page_extension, '.html'
    base.set :cache_logging, true
    base.set :cache_logging_level, :info
  end
  
  def cache(content, &block)
    return content unless options.caching
    unless content.nil?
      content = "#{content}\n#{page_cached_timestamp}"
      path = cache_page_path(request.path_info)
      FileUtils.makedirs(File.dirname(path))
      open(path, 'wb+') { |f| f << content }
      log("Cached Page: [#{path}]",:info) 
      content
    end
  end
    
  def cache_expire(path = nil)
    return unless options.caching
    
    path = (path.nil?) ? cache_page_path(request.path_info) : cache_page_path(path)
    
    if File.exist?(path)
      File.delete(path)
      log("Expired Page deleted at: [#{path}]",:info)
    else
      log("No Expired Page was found at the path: [#{path}]",:info)
    end
  end
  
  def page_cached_timestamp
    "<!-- cached: #{Time.now.strftime("%Y-%d-%m %H:%M:%S")} -->\n" if options.caching
  end

private
    
  def cache_file_name(path)
    name = (path.empty? || path == "/") ? "index" : Rack::Utils.unescape(path.sub(/^(\/)/,'').chomp('/'))
    name << options.cache_page_extension
    return name
  end
  
  def cache_page_path(path)
    cache_dir = (options.cache_output_dir == File.expand_path(options.cache_output_dir)) ? options.cache_output_dir : File.expand_path("#{options.public}/#{options.cache_output_dir}")
    cache_dir = options.cache_output_dir[0..-2] if cache_dir[-1,1] == '/'
    
    "#{cache_dir}/#{cache_file_name(path)}"
  end
  
  def log(msg,scope=:debug)
  end
  
end