load 'deploy' if respond_to?(:namespace) # cap2 differentiator

set :application, "snippets"
set :repository,  "http://webop.svnme.com/snippets/trunk"
set :deploy_to, "/www/webop/apps/#{application}"

set :scm, :subversion
# set :deploy_via, :remote_cache
set :use_sudo, false

set :user, 'hurrinre'
role :app, "renpppcmhdev01.reedref.com"

namespace :deploy do
  desc "Restart Application"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

namespace :cache do
  desc "Clean Cache"
  task :clean do
    run "cd #{current_path}; /usr/bin/rake cache:expire_all"
  end
end

after :deploy, 'deploy:cleanup'
