load 'deploy' if respond_to?(:namespace) # cap2 differentiator

set :application, 'snippets'
set :deploy_to, "/www/webop/apps/#{application}"

set :user, 'hurrinre'
set :domain, 'renpppcmhdev01.reedref.com'
role :app, domain
set :use_sudo, false

set :scm, :git
set :repository, "file:///var/git/#{application}.git"
set :local_repository, "#{user}@#{domain}:/var/git/#{application}.git"
set :branch, 'master'

namespace :deploy do
  desc "Restart Application"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

after :deploy, 'deploy:cleanup'
