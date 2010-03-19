require 'fileutils'
require 'pathname'

# NOTE: based off another sinatra-cache gem, but can't remember which since it was a while ago. put the credits in here

module Caching
  def self.included(base)
    base.disable :caching
    base.set :cache_output_dir, ''
    base.set :cache_page_extension, '.html'
  end
  
  def cache(content, &block)
    return content unless options.caching
    unless content.nil?
      content = "#{content}\n#{page_cached_timestamp}"
      path = cache_page_path(request.path_info)
      FileUtils.makedirs(File.dirname(path))
      open(path, 'wb+') { |f| f << content }
      content
    end
  end
    
  def cache_expire(path = nil)
    return unless options.caching
    
    path = (path.nil?) ? cache_page_path(request.path_info) : cache_page_path(path)
    
    if File.exist?(path)
      File.delete(path)
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
end