RakeRoot = File.dirname(__FILE__)

task :environment do
  require RakeRoot+'/lib/environment.rb'
end

namespace :cache do
  desc 'Expire all cached files'
  task :expire_all do
    require 'fileutils'
    cache_root = File.join(File.dirname(__FILE__), 'public')
    
    folders = Dir["#{cache_root}/{history,diff}"]
    files = Dir["#{cache_root}/*.html"]
    (folders + files).each{ |file| FileUtils.rm_rf(file) }
  end
end

namespace :db do
  desc "Migrate the database"  
  task :migrate => :environment do
    ActiveRecord::Migrator.migrate(RakeRoot+'/migrations', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )  
  end  
end