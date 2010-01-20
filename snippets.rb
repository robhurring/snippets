$: << File.join(File.dirname(__FILE__), 'lib')
require 'environment'

class Snippets < Sinatra::Base
  include Caching
  AnalyticsCode = ''
  
  use ActiveRecord::ConnectionAdapters::ConnectionManagement
  use ActiveRecord::QueryCache # only works for default AR::Base connections, newly established_connections won't inherit the caching
  
  use Rack::Flash, :sweep => true, :accessorize => [:notice]
  use Rack::Static, :urls => ['/css', '/images', '/js'], :root => 'public'    
  
  enable :sessions, :logging, :dump_errors, :static
  set :environment => (ENV['RACK_ENV'] || :development), :host => 'webops.local.com'
  set :public, File.dirname(__FILE__)+'/public'
  
  configure(:production) do
    use Rack::GoogleAnalytics, :web_property_id => AnalyticsCode
    enable :caching
  end
  
  configure do
    Log = Logger.new('log/snippets.log')
  end
  
  helpers Sinatra::Helpers

# Default Routes
  
  before do
    @updated_snippets = Snippet.all(:order => 'updated_at DESC', :limit => 10)
  end

  not_found do
    cache( erb :"404" )
  end
  
  error do
    cache( erb :"500" )
  end

# Main Pages

  get '/?' do    
    cache( erb :index )
  end 
  
  get '/all' do
    @snippets = Snippet.all
    cache( erb :"snippets/all" )
  end

# Add Snippet 

  get '/new' do
    @snippet = Snippet.new
    cache( erb :"snippets/new" )
  end
  
  post '/new' do
    @snippet = Snippet.new(params[:snippet])
    if @snippet.save
      cache_expire_all
      redirect url_for("/#{@snippet.title}")
    else
      erb :"snippets/new"
    end
  end
  
# Edit Snippet

  get '/edit/:title' do
    @snippet = Snippet.find_by_title(params[:title].downcase)
    if @snippet
      @title = "Edit Snippet > #{@snippet.title}"
      erb :"snippets/edit"
    else
      not_found
    end
  end

  post '/edit/:title' do
    @snippet = Snippet.find_by_title(params[:title].downcase)
    if @snippet.update_attributes(params[:snippet])
      cache_expire_all
      redirect url_for("/#{@snippet.title}")
    else
      erb :"snippets/edit"
    end
  end
  
# Remove

  get '/remove/:title' do
    snippet = Snippet.find_by_title(params[:title].downcase)
    if snippet
      if snippet.destroy
        expire_snippet_cache(snippet)
        redirect url_for("/")
      else
        error
      end
    else
      not_found
    end      
  end
  
# Revert

  get '/revert/:title/:revision' do
    snippet = Snippet.find_by_title(params[:title].downcase)
    
    if snippet
      if snippet.revert_to(params[:revision].to_i)
        expire_snippet_cache(snippet)
        redirect url_for("/#{snippet.title}")
      else
        error
      end
    else
      not_found
    end
  end
  
# History

  get '/history/:title' do
    @snippet = Snippet.find_by_title(params[:title].downcase)
    if @snippet
      @history = @snippet.revisions.all(:order => 'version DESC')
      cache( erb :"snippets/history" )
    else
      not_found
    end
  end

# View Snippet

  get '/diff/:title/:revision' do
    revision = params[:revision].to_i
    @current_snippet = Snippet.find_by_title(params[:title].downcase)
    
    if @current_snippet
      diff_snippet = @current_snippet.revision(revision)
      @diff = diff_snippet.data.diff(@current_snippet.data, 
        :mine => "Version #{diff_snippet.version} \t #{diff_snippet.updated_at.strftime('%m/%d/%Y @ %H:%M')}", 
        :theirs => "Version #{@current_snippet.version} \t #{@current_snippet.updated_at.strftime('%m/%d/%Y @ %H:%M')}")
        
      cache( erb :"snippets/diff" )
    else
      not_found
    end
  end

  get '/:title/?*' do
    @snippet = Snippet.find_by_title(params[:title].downcase)
    @revision = params[:splat].first.to_i

    if @snippet
      cache( erb :"snippets/show" )
    else
      not_found
    end
  end
  
private

  def cache_expire_all
    return unless options.caching
    
    folders = Dir["#{options.public}/{history,diff}"]
    files = Dir["#{options.public}/*.html"]
    (folders + files).each{ |file| FileUtils.rm_rf(file) }
  end

  def expire_snippet_cache(snippet)
    return unless options.caching
    
    Dir["#{options.public}/{.,history,diff}/#{snippet.title}*"].each{ |file| FileUtils.rm_rf(file) }
  end
  
end