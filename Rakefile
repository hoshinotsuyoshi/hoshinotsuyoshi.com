# frozen_string_literal: true
# see https://gohugo.io/tutorials/github-pages-blog/

require 'date'
require 'erb'
require 'time' # Time#iso8601

DIST  = 'dist'
THEME = 'casper'
HUGO_VERSION = 'Hugo Static Site Generator v0.55'

task default: 'deploy:run'

namespace :deploy do
  desc 'Deploy'
  task run: [
    :install_theme,
    :update_truthy_or_falsy,
    :check_hugo_version,
    :dist,
    :deploy_sh
  ]

  desc 'Install theme'
  task :install_theme do
    sh 'git submodule init'
    sh 'git submodule update'
  end

  desc 'Check hugo version'
  task :check_hugo_version do
    `hugo version`.start_with?(HUGO_VERSION) || abort("You should use '#{HUGO_VERSION}'")
  end

  desc 'Run hugo, put files to "dist" dir'
  task :dist do
    sh "HUGO_THEME=#{THEME} hugo -d #{DIST}"
  end

  desc 'Update truthy_or_falsy dir'
  task :update_truthy_or_falsy do
    sh 'mkdir -p dist'
    sh 'rm -rf dist/ruby_truthy_or_falsy/'
    sh 'cp -R truthy_or_falsy dist/ruby_truthy_or_falsy'
  end

  desc 'Run deploy.sh'
  task :deploy_sh do
    sh './deploy.sh'
  end
end

namespace :entry do
  desc 'Put a new entry'
  task :new, 'title'
  task :new do |_task, args|
    template = ERB.new(File.read('entry_template.md.erb'))
    @slug = args['title'] || 'slug'
    File.write(
      "./content/post/#{Date.today}_#{@slug}.md",
      template.result
    )

    puts "lets do this command"
    puts "rake 'pixela:create_access_counter_url[#{Date.today.strftime('%Y%m%d')}-1]'"
  end
end

desc 'Serve html locally'
task :server do
  sh "HUGO_THEME=#{THEME} hugo server"
end

# alias
desc '(Alias)Serve html locally'
task s: :server

namespace :pixela do
  desc 'Create pixela access counter url'
  task :create_access_counter_url, 'value'
  task :create_access_counter_url do |_task, args|
    v = args['value']
    command = %(curl -X POST https://pixe.la/v1/users/hoshinotsuyoshi/graphs -H "X-USER-TOKEN:${PIXELA_TOKEN}" -d '{"id":"hblog-#{v}","name":"hblog-#{v}","unit":"view(s)","type":"int","color":"shibafu","timezone":"Asia/Tokyo","selfSufficient":"increment"}')
    puts command
  end
end
