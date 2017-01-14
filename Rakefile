# frozen_string_literal: true
# see https://gohugo.io/tutorials/github-pages-blog/

require 'date'
require 'erb'
require 'time' # Time#iso8601

DIST  = 'dist'
THEME = 'casper'

task default: :deploy

desc 'Deploy'
task deploy: [:install_theme, :dist, :check_cname, :deploy_sh]

desc 'Install theme'
task :install_theme do
  sh 'git submodule init'
  sh 'git submodule update'
end

desc 'Run hugo, put files to "dist" dir'
task :dist do
  sh "hugo -d #{DIST} -t #{THEME}"
end

desc 'Check "CNAME" file(a special file for github-page)'
task :check_cname do
  File.exist?("#{DIST}/CNAME") || abort('ERROR! CNAME file not found.')
  puts 'CNAME file exists.'
end

desc 'Run deploy.sh'
task :deploy_sh do
  sh './deploy.sh'
end

desc 'Serve html locally'
task :server do
  sh "hugo server -t #{THEME}"
end

# alias
desc '(Alias)Serve html locally'
task s: :server

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
  end
end
