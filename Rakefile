RakeRoot = File.dirname(__FILE__)

task :environment do
  require RakeRoot+'/lib/environment.rb'
end

namespace :db do
  desc "Migrate the database"  
  task :migrate => :environment do
    ActiveRecord::Migrator.migrate(RakeRoot+'/migrations', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )  
  end  
end