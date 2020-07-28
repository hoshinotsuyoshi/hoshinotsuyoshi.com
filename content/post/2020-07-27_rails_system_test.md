+++
date = "2020-07-28T10:36:13+09:00"
draft = false
title = "docker-composeでの開発環境やCIでRailsのSystem Testするやつ"
slug = "rails_system_test"
tags = ["rails","rspec"]
image = "images/ghost.jpg"
+++


[System Test](https://guides.rubyonrails.org/testing.html#system-testing)を手元のdocker-compose環境及びCIでやる方法について、雰囲気でまとめました。


<!--more-->

## 問題意識

昨今は `docker-compose` で開発環境を構築しがちだと思うのですが、その場合のブラウザの自動テスト([System Test](https://guides.rubyonrails.org/testing.html#system-testing)) のやり方がよくわかっていなかったので調べてみました。

スクショとCIについても少し触れます。

## TOC

* めでたく動いた様子はこちら
* 今回適用した差分PR
* さよなら `webdrivers`
   * ブラウザをdockerizeするにはどうするか
* スクショどうなるの
* `画面共有.app` で動きを覗く


## めでたく動いた様子はこちら

今回は手元の自分のfastladderでやっていきます。 

さて、Railsは5.1あたりからCapybaraの連携がだいぶ楽になっています。

なので、今回は手元の自分のfastladderをあらかじめ **雑にRails4.2 -> Rails6.0にしておきました。** 

<img alt="" src="/images/system_test_fastladder_ubuntu.gif" width=800>



## 今回適用した差分PR

PRはこちらです

* https://github.com/hoshinotsuyoshi/fastladder/pull/6
  * CI https://github.com/hoshinotsuyoshi/fastladder/runs/912028519

<a class="embedly-card" data-card-controls="0" href="https://github.com/hoshinotsuyoshi/fastladder/pull/6">System test by hoshinotsuyoshi · Pull Request #6 · hoshinotsuyoshi/fastladder</a>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

diffはこちらです

```diff

commit 5d550624332c3d535c08e5dfe0ed5bdfc9783f72
Author: hoshinotsuyoshi <guitarpopnot330@gmail.com>
Date:   Sun Jul 26 23:46:44 2020 +0900

    System test

diff --git a/.github/workflows/ci.yml b/.github/workflows/ci.yml
index 4c00fde..9f76a99 100644
--- a/.github/workflows/ci.yml
+++ b/.github/workflows/ci.yml
@@ -12,11 +12,14 @@ jobs:
         env:
           TZ: Asia/Tokyo
           MYSQL_ROOT_PASSWORD: root
+      webdriver_chrome:
+        image: selenium/standalone-chrome
 
     container:
       image: ruby:2.6.6
       env:
         RAILS_ENV: test
+        SELENIUM_REMOTE_URL: http://webdriver_chrome:4444/wd/hub
         TZ: Asia/Tokyo
 
     steps:
diff --git a/Gemfile b/Gemfile
index f19bd64..8f00212 100644
--- a/Gemfile
+++ b/Gemfile
@@ -76,6 +76,7 @@ group :test do
   gem 'rails-controller-testing'
   gem 'rspec-activemodel-mocks'
   gem 'rspec-rails'
+  gem 'selenium-webdriver'
   gem 'simplecov'
   gem 'simplecov-rcov'
   gem 'sinon-rails'
diff --git a/Gemfile.lock b/Gemfile.lock
index 0dc38fa..cf4c822 100644
--- a/Gemfile.lock
+++ b/Gemfile.lock
@@ -79,6 +79,7 @@ GEM
       rack-test (>= 0.6.3)
       regexp_parser (~> 1.5)
       xpath (~> 3.2)
+    childprocess (3.0.0)
     cliver (0.3.2)
     coderay (1.1.3)
     coffee-rails (5.0.0)
@@ -248,6 +249,7 @@ GEM
       rspec-mocks (~> 3.9)
       rspec-support (~> 3.9)
     rspec-support (3.9.3)
+    rubyzip (2.3.0)
     safe_yaml (1.0.5)
     sassc (2.4.0)
       ffi (~> 1.9)
@@ -258,6 +260,9 @@ GEM
       sprockets-rails
       tilt
     sax-machine (1.3.2)
+    selenium-webdriver (3.142.7)
+      childprocess (>= 0.5, < 4.0)
+      rubyzip (>= 1.2.2)
     settingslogic (2.0.9)
     simplecov (0.18.5)
       docile (~> 1.1)
@@ -333,6 +338,7 @@ DEPENDENCIES
   rspec-activemodel-mocks
   rspec-rails
   sassc-rails
+  selenium-webdriver
   settingslogic
   simplecov
   simplecov-rcov
diff --git a/docker-compose.yml b/docker-compose.yml
index 3a41e10..2ac74a7 100644
--- a/docker-compose.yml
+++ b/docker-compose.yml
@@ -20,16 +20,24 @@ services:
       context: .
     command: /bin/sh -c "bundle install && rm -f /app/tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'"
     environment:
+      SELENIUM_REMOTE_URL: http://webdriver_chrome:4444/wd/hub
       TZ: Asia/Tokyo
     volumes:
       - .:/app
       - bundle:/usr/local/bundle
     stdin_open: true
     tty: true
+
     ports:
     - 3001:3000
     depends_on:
       - db
+      - webdriver_chrome
+  webdriver_chrome:
+    image: selenium/standalone-chrome-debug
+    ports:
+      - 4444:4444
+      - 5900:5900
 volumes:
   bundle:
   node-modules:
diff --git a/spec/support/capybara.rb b/spec/support/capybara.rb
new file mode 100644
index 0000000..a7ff3d2
--- /dev/null
+++ b/spec/support/capybara.rb
@@ -0,0 +1,13 @@
+Capybara.server_host = Socket.ip_address_list.detect{|addr| addr.ipv4_private?}.ip_address
+Capybara.server_port = 3002
+RSpec.configure do |config|
+  config.before(:each, type: :system) do
+    driven_by :selenium, using: :headless_chrome, options: {
+      browser: :remote,
+      url: ENV.fetch("SELENIUM_REMOTE_URL"),
+      desired_capabilities: :chrome
+    }
+    host! "http://#{Capybara.server_host}:#{Capybara.server_port}"
+    WebMock.allow_net_connect!
+  end
+end
diff --git a/spec/system/main_spec.rb b/spec/system/main_spec.rb
new file mode 100644
index 0000000..9b01aa1
--- /dev/null
+++ b/spec/system/main_spec.rb
@@ -0,0 +1,22 @@
+require 'spec_helper'
+
+describe 'main' do
+  it 'renders a new account form' do
+    visit '/'
+    expect(page).to have_content "Create new account"
+    click_button 'Sign Up'
+
+    # error
+    expect(current_path).to eq('/members')
+    expect(page).to have_content "can't be blank"
+
+    fill_in('Username', with: 'harry')
+    fill_in('Password', with: 'insecure-password')
+    fill_in('Confirm Password', with: 'insecure-password')
+    click_button 'Sign Up'
+
+    # logged in
+    expect(current_path).to eq('/reader/')
+    expect(page).to have_content "Quick Guide"
+  end
+end
```

<br/>

説明していきます

<br/>
<br/>



## さよなら `webdrivers`

さて、docker-composeでなくてmac上で開発しているときは `webdrivers` という超絶便利gemがありました(前身は `chromedriver-helper`)。

> [サポートが終了したchromedriver-helperからwebdrivers gemに移行する手順 - Qiita](https://qiita.com/jnchito/items/f9c3be449fd164176efa)

この `webdrivers`は、どんな子かというと、手元のマシンのChromeがどんどんバージョンが上がっていってしまう中で、それを動かすための `chromedriver` を(`chromedriver`に限らないですが)いいタイミングでいい感じにアップデートしてくれるっていう、いい奴でした。

しかしdocker-compose上で開発する際には一旦忘れても良いかもしれません。


### ブラウザの環境が違うと落ちるテストがある!

ところで、`chromedriver` のバージョンが固定されることで安定性が高まるかと思えど、そうでもない場合もあって、経験上、以下のようなCapybaraのテストは、環境によっては不安定になります。


例えば、viewが

```erb
<%= form_for(user) do |f| %>
  <%= f.label :birthday %>
  <%= f.date_field :birthday %>
  ...
```

みたいになってて(`input type="date"`)、テストが

```ruby
  fill_in '生年月日', with: "19851026"
```

みたいになってるやつです。

このテストは、ブラウザが日本語設定されているとちゃんとyyyymmddとして解釈されますが、

ブラウザが英語設定されていると mmddyyyyと解釈されてしまいます。

Capybara君は愚直に受け取った文字列をフォームに突っ込んでいくだけなので、この環境の差異を察してくれないのです。

今回はdocker-compose使うため、ブラウザ自体もdockerizeされるので、この環境差異問題は解決されます。

### ブラウザをdockerizeするにはどうするか -> Selenium::WebDriver では `browser: :remote` というオプションが渡せる

しかしpumaとかrspecが動くコンテナの中にブラウザをインストールするのは辛そうだな、と思っていたところ、 **ググってみるとどうやら皆さんブラウザ自体は別コンテナで動かしている** ようでした。

Selenium::WebDriverの機能で、Railsが動くコンテナの中に直接ブラウザをインストールせずにやっていくことができます。

Selenium::WebDriverには [`Selenium::WebDriver::Remote::Driver`](https://www.selenium.dev/selenium/docs/api/rb/Selenium/WebDriver/Remote/Driver.html) なるものがあり、 `url:` オプションで別ホストのブラウザのURLを渡すことにより、Webアプリケーションの動くコンテナ以外のところでブラウザを動かすことができます。


さっきのPRで言うと、ここの部分です。

```diff
+    driven_by :selenium, using: :headless_chrome, options: {
+      browser: :remote,
+      url: ENV.fetch("SELENIUM_REMOTE_URL"),
+      desired_capabilities: :chrome
+    }
```


このやり方は昔からあるみたいです。 ( https://www.altoros.com/blog/running-capybara-tests-in-remote-browsers/ )

知らなかった。。 ググると皆さんこの方法でやっているようです。

* [ruby on rails - docker-compose+Rails5.1+rspec+HeadlessChromeでのサブドメインのテスト方法がわかりません - スタック・オーバーフロー](https://ja.stackoverflow.com/questions/43173/docker-composerails5-1rspecheadlesschrome%E3%81%A7%E3%81%AE%E3%82%B5%E3%83%96%E3%83%89%E3%83%A1%E3%82%A4%E3%83%B3%E3%81%AE%E3%83%86%E3%82%B9%E3%83%88%E6%96%B9%E6%B3%95%E3%81%8C%E3%82%8F%E3%81%8B%E3%82%8A%E3%81%BE%E3%81%9B%E3%82%93)
* [Rails on Docker(alpine)でdocker-seleniumを使わないでSelenium+RSpec+Capybaraでテスト自動化してみる - Qiita](https://qiita.com/at-946/items/6def89bb94f748ad97f2)


seleniumが用意しているdocker imageを使うのですね。


やり方は、docker-composeではそういうserviceを立ち上げれば良くて、

```yaml
  webdriver_chrome:
    image: selenium/standalone-chrome
    ports:
      - 4444:4444
```

webアプリケーションの動くコンテナ側にはその場所を環境変数で教えてあげれば良いです。

```yaml
environment:
  SELENIUM_REMOTE_URL: http://webdriver_chrome:4444/wd/hub
```

<br>
<br>


## スクショ はどうなるのか

スクショについては、昔からCapybaraに`#save_screenshot` というメソッドが生えてるので、それを使うことができます。

> [CapybaraでJSを使ったテストは save_screenshot が便利 - Qiita](https://qiita.com/showwin/items/cf047bfd9a3c08781bf7)

さらに言うと、[mattheworiordan/capybara-screenshot](https://github.com/mattheworiordan/capybara-screenshot) という便利gemがあり、テストが落ちた時に勝手にスクショを撮ってくれます。

さらにさらに、5.1以上のRailsだと勝手にこれをやってくれます。(今の話はなんだったんだ)。
おそらく[このあたり](https://github.com/rails/rails/blob/v6.0.3.2/actionpack/lib/action_dispatch/system_testing/test_helpers/screenshot_helper.rb)です。

便利ですね。

### CIでのスクショ

ということで、System Testがfailしたときはデフォルトでtmp/screenshotにスクショが置かれますので、CIではこれをartifact化すれば良いわけです。簡単。

GitHub Actionsの例だと、こんな感じです。`tmp/screenshot/.keep`を あらかじめtouchしておいた方がいいかも。

```yaml
    - name: Archive screenshots and logs of system tests
      uses: actions/upload-artifact@v2
      if: failure()
      with:
        name: logs
        path: |
          tmp/screenshots
          log/test.log
```

<br>

ちなみに[このあたり](https://github.com/rails/rails/blob/v6.0.3.2/actionpack/lib/action_dispatch/system_testing/test_helpers/screenshot_helper.rb#L20-L21)にある通り、
環境変数`RAILS_SYSTEM_TESTING_SCREENSHOT=inline` をセットしてあげると、iTerm2を使っている場合はテストがfailしたときにターミナルにスクショが出るそうです。何それ便利そう(iTerm使ってないので未確認)。

<br>
<br>

## `画面共有.app` で動きを覗く

これも参考にした記事

[Rails on DockerでRSpecのSystem testをSelenium Dockerを使ってやってみた。 - Qiita](https://qiita.com/at-946/items/e96eaf3f91a39d180eb3) 

のそのまんまですが、

docker-compose時の 使用イメージ `selenium/standalone-chrome` に替えて `selenium/standalone-chrome-debug` を指定し、ポート5900をexposeすればmacOSの `画面共有.app` で覗くことができます。


```yaml
  webdriver_chrome:
    image: selenium/standalone-chrome-debug
    ports:
      - 4444:4444
      - 5900:5900
```

`$ docker-compose up` したあと、 rspecを実行(`$ docker-compose run --rm app bundle exec rspec spec/system`)する前に

```
# パスワードは「secret」
$ open vnc://localhost:5900
```

とかやれば画面共有.appが立ち上がります。


<img alt="" src="/images/system_test_fastladder_ubuntu.gif" width=800>

## ✍️まとめ

docker-composeを使うことにより、少なくとも普通のChromeを動かす分には、`webdrivers` gemとさよならできました。

ここ数年のRailsは、Capybaraとの連携が深まっていて、どんどんやりやすくなっていっています。

<script type="text/javascript" src="/js/prism.js" async></script>
