# see https://gohugo.io/tutorials/github-pages-blog/

DIST  = 'dist'
THEME = 'casper'

task default: :deploy

desc 'Deploy'
task deploy: [:dist, :check_cname, :deploy_sh]

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
