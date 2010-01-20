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

after :deploy, 'deploy:cleanup'
