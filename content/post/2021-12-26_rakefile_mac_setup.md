+++
date = "2021-12-26T10:12:52+09:00"
draft = false
title = "RakefileでMacのセットアップ"
slug = "rakefile_mac_setup"
tags = ["ruby"]
# image = "images/slack_display.png"
image = "defimg/3.jpg"
+++


RakefileでMacのセットアップするようにしてる話

<!--more-->

`$ rake` するだけで同じ状態に収束するようにしています。 便利

# Rakefileの雰囲気

```ruby
def home
  @home ||= ENV['HOME'] || abort('Error. Set env `HOME`')
end

def ghq_dir
  "#{home}/ghq"
end

def red_puts(string)
  print "\e[31m"
  puts string
  print "\e[0m"
end

def which(string)
  sh "which #{string}"
end

def ghq_get(string)
  sh "ghq get #{string} || true"
end

task default: :main
task main: [
  # VS Code
  :check_code,

  # tmux
  :check_tmux,
  :cp_tmux_files,

  # git
  :cp_git_files,

  # direnv
  :check_direnv,

  # neovim
  :check_neovim,
  :check_pip3_neovim,
  :check_gem_neovim,
  :cp_nvim_files,

  # zsh
  :cp_zsh_files,

  # rbenv
  :rbenv_ruby_build,
  :rbenv_default_gems,
  :cp_rbenv_files,

  # asdf
  :check_asdf,
  # :check_asdf_rust,
  # ....

  # success message
  :success,
]
task :check_macports do
  which 'port'
rescue => e
  red_puts 'error!'
  red_puts 'Install MacPorts. visit https://www.macports.org'
  abort e.to_s
end

task check_tmux: [:check_macports, :check_reattach_to_user_namespace] do
  which 'tmux'
rescue => e
  red_puts 'error!'
  red_puts 'Do $ sudo port install tmux'
  abort e.to_s
end

task check_reattach_to_user_namespace: :check_macports do
  which 'reattach-to-user-namespace'
rescue => e
  red_puts 'error!'
  red_puts 'Do $ sudo port install tmux-pasteboard'
  abort e.to_s
end

task :cp_tmux_files do
  cp '.tmux.conf', "#{home}/.tmux.conf"
end

task :cp_git_files do
  ['.gitconfig', '.gitignore_global'].each do |f|
    cp f, "#{home}/#{f}"
  end

  rm_rf "#{home}/.git_template"
  cp_r '.git_template/', "#{home}/.git_template"
end

task check_direnv: :check_macports do
  which 'direnv'
rescue => e
  red_puts 'error!'
  red_puts 'Do $ sudo port install direnv'
  abort e.to_s
end

task check_neovim: :check_macports do
  which 'nvim'
rescue => e
  red_puts 'error!'
  red_puts 'Do $ sudo port install neovim'
  abort e.to_s
end

task :check_pip3_neovim do
  sh 'pip3 list 2>/dev/null | grep -q "^neovim\s"'
rescue => e
  red_puts 'error!'
  red_puts 'Do $ pip3 install neovim'
  abort e.to_s
end

task :check_gem_neovim do
  sh 'gem list | grep -q "^neovim\s"'
rescue => e
  red_puts 'error!'
  red_puts 'Do $ gem install neovim'
  abort e.to_s
end

task cp_nvim_files: :check_iceberg do
  mkdir_p "#{home}/.config"
  rm_rf "#{home}/.config/nvim"
  cp_r '.config/nvim', "#{home}/.config"
end

task check_iceberg: [:check_ghq, '/opt/local/share/nvim/runtime/colors/iceberg.vim']
file '/opt/local/share/nvim/runtime/colors/iceberg.vim' do
  ghq_get 'github.com/cocopon/iceberg.vim'
  sh "sudo ln -fs #{ghq_dir}/github.com/cocopon/iceberg.vim/colors/iceberg.vim /opt/local/share/nvim/runtime/colors/iceberg.vim"
end

task check_peco: :check_macports do
  which 'peco'
rescue => e
  red_puts 'error!'
  red_puts 'Do $ sudo port install peco'
  abort e.to_s
end

task check_ghq: :check_go do
  which 'ghq'
rescue => e
  red_puts 'error!'
  red_puts 'Do $ go install github.com/x-motemen/ghq@v1.2.1'
  abort e.to_s
end

task check_go: :check_macports do
  which 'go'
rescue => e
  red_puts 'error!'
  red_puts 'Do $ sudo port install go'
  abort e.to_s
end

task :check_code do
  which 'code'
rescue => e
  red_puts 'error!'
  red_puts <<~EOM
    see https://qiita.com/ayatokura/items/69c96306e3dee501e19b
    1. VSCodeをインストール・起動する
    2. コマンドパレットで `>Shell` と入力し、シェルコマンドのメニューを表示する。
    3. 「シェルコマンド: PAHT内にVS Codeをインストールします (Shell Command: Install code command in PATH)」を選択する。
  EOM
  abort e.to_s
end

task check_z: [:check_ghq, "#{ghq_dir}/github.com/rupa/z/z.sh"]
file "#{ghq_dir}/github.com/rupa/z/z.sh" do
  ghq_get 'github.com/rupa/z'
end

task cp_zsh_files: [:check_z, :check_peco] do
  cp '.zshrc', "#{home}/.zshrc"
end

task rbenv: "#{ghq_dir}/github.com/rbenv/rbenv"
directory "#{ghq_dir}/github.com/rbenv/rbenv" do
  ghq_get 'github.com/rbenv/rbenv'
end

task rbenv_ruby_build: [:rbenv, "#{ghq_dir}/github.com/rbenv/ruby-build"]
directory "#{ghq_dir}/github.com/rbenv/ruby-build" do
  ghq_get 'github.com/rbenv/ruby-build'
  mkdir_p "#{home}/.rbenv/plugins"
  unless File.exist?("#{home}/.rbenv/plugins/ruby-build")
    ln_s "#{ghq_dir}/github.com/rbenv/ruby-build", "#{home}/.rbenv/plugins"
  end
end

task rbenv_default_gems: [:rbenv, "#{ghq_dir}/github.com/rbenv/rbenv-default-gems"]
directory "#{ghq_dir}/github.com/rbenv/rbenv-default-gems" do
  ghq_get 'github.com/rbenv/rbenv-default-gems'
  mkdir_p "#{home}/.rbenv/plugins"
  unless File.exist?("#{home}/.rbenv/plugins/rbenv-defaut-gems")
    ln_s "#{ghq_dir}/github.com/rbenv/rbenv-defaut-gems", "#{home}/.rbenv/plugins"
  end
end

task :cp_rbenv_files do
  mkdir_p "#{home}/.rbenv"
  cp '.rbenv/default-gems', "#{home}/.rbenv/default-gems"
end

task check_asdf: "#{ghq_dir}/github.com/asdf-vm/asdf"
directory "#{ghq_dir}/github.com/asdf-vm/asdf" do
  ghq_get 'github.com/asdf-vm/asdf'
  ln_sf "#{ghq_dir}/github.com/asdf-vm/asdf", "#{home}/.asdf"
end

task :success do
  puts
  puts 'success!'
end
```

<br>

今回はちょっと古いMac `MacBook Pro (13-inch, M1, 2020)` を買いましたが、

Monterey時点でも `/usr/bin/ruby` や `/usr/bin/rake` はまだ存在するようです。やったね。

rakeは、シェルスクリプト頑張って書くのに比べて本当に簡単で強力なので、しばらくMacに標準で載っけておいてほしいです。まあ仮に無くなっても頑張って入れますが...

<script type="text/javascript" src="/js/prism.js" async></script>
