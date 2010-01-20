$: << File.join(File.dirname(__FILE__), 'lib')
require 'environment'

class Snippets < Sinatra::Base
  AnalyticsCode = ''
  
  use ActiveRecord::ConnectionAdapters::ConnectionManagement
  use ActiveRecord::QueryCache # only works for default AR::Base connections, newly established_connections won't inherit the caching
  
  use Rack::Flash, :sweep => true, :accessorize => [:notice]
  use Rack::Static, :urls => ['/css', '/images', '/js'], :root => 'public'    
  
  enable :sessions, :logging, :dump_errors, :static
  set :environment => (ENV['RACK_ENV'] || :development), :host => 'webops.local.com'
  
  configure(:production) do
    use Rack::GoogleAnalytics, :web_property_id => AnalyticsCode
  end
  
  helpers Sinatra::Helpers

# Default Routes
  
  before do
    @updated_snippets = Snippet.all(:order => 'updated_at DESC', :limit => 10)
  end

  not_found do
    erb :"404"
  end
  
  error do
    erb :"500"
  end

  get '/?' do    
    erb :index
  end 
  
  get '/all' do
    @snippets = Snippet.all
    erb :"snippets/all"
  end

# Add Snippet 

  get '/new' do
    @snippet = Snippet.new
    erb :"snippets/new"
  end
  
  post '/new' do
    @snippet = Snippet.new(params[:snippet])
    unless @snippet.save
      erb :"snippets/new"
    else
      redirect url_for("/#{@snippet.title}")
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
      redirect url_for("/#{@snippet.title}")
    else
      erb :"snippets/edit"
    end
  end
  
# Remove

  get '/remove/:title' do
    @snippet = Snippet.find_by_title(params[:title].downcase)
    if @snippet
      if @snippet.destroy
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
      erb :"snippets/history"
    else
      not_found
    end
  end

# View Snippet

  get '/diff/:title/:revision' do
    revision = params[:revision].to_i
    current_snippet = Snippet.find_by_title(params[:title].downcase)
    
    if current_snippet
      diff_snippet = current_snippet.revision(revision)
      @diff = diff_snippet.data.diff(current_snippet.data, 
        :mine => "Version #{diff_snippet.version} \t #{diff_snippet.updated_at.strftime('%m/%d/%Y @ %H:%M')}", 
        :theirs => "Version #{current_snippet.version} \t #{current_snippet.updated_at.strftime('%m/%d/%Y @ %H:%M')}")
        
      erb :"snippets/diff"
    else
      not_found
    end
  end

  get '/:title/?*' do
    @snippet = Snippet.find_by_title(params[:title].downcase)
    @revision = params[:splat].first.to_i

    if @snippet
      erb :"snippets/show"
    else
      not_found
    end
  end
  
end