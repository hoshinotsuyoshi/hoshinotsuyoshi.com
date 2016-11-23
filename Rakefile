# see https://gohugo.io/tutorials/github-pages-blog/

DIST  = 'dist'
THEME = 'casper'

task default: :deploy

desc 'Deploy'
task deploy: [:install_theme, :dist, :check_cname, :deploy_sh]

desc 'Install theme'
task :install_theme do
  puts
  sh "git submodule init"
  sh "git submodule update"
end

desc 'Run hugo, put files to "dist" dir'
task :dist do
  puts
  sh "hugo -d #{DIST} -t #{THEME}"
end

desc 'Check "CNAME" file(a special file for github-page)'
task :check_cname do
  puts
  File.exist?("#{DIST}/CNAME") || abort('ERROR! CNAME file not found.')
  puts 'CNAME file exists.'
end

desc 'Run deploy.sh'
task :deploy_sh do
  puts
  sh './deploy.sh'
end

desc 'Serve html locally'
task :server do
  puts
  sh "hugo server -t #{THEME}"
end

# alias
desc '(Alias)Serve html locally'
task s: :server
