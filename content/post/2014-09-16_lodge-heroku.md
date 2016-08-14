+++
date = "2014-09-16T00:00:00+09:00"
draft = true
title = "[テスト投稿]Lodgeをherokuで動かす(ついでにheroku button)"
slug = "logde-heroku"
tags = ["logde", "heroku"]
image = "images/saturn-sendai-city-museum.jpg"

+++

Lodgeをherokuで動かす(ついでにheroku button)
## Lodgeとは

Lodgeは、オープンソースの情報共有アプリです。

* [lodge/lodge](https://github.com/lodge/lodge)
* [無料でイントラネット内にナレッジ/ノウハウの共有ができる「Lodge」](http://qiita.com/m-yamashita/items/d6f64db461acd54095f7)

## herokuにデプロイしてみた

「データを外部業者に預けずにオンプレで管理できる」のが特色のlodgeを、クラウド環境にデプロイするのは色々と相反している気もしますが、気にしない方針でいきます。
あとついでにheroku buttonを使ってみました。

## こんな感じで編集しました

https://github.com/hoshinotsuyoshi/lodge/commit/41d71fb77b82e287506d727dfacbc3e08d6dc80d

## つまり、やったこと

* 環境変数設定を
    * app.jsonに一部書く
    * config/environments/production.rbに一部書く
* bundle installしてGemfile.lockを.gitignoreから外す
* config/database.ymlを書いて.gitignoreから外す
* 自分のlodgeのREADME.mdにheroku buttonを追加

## herokuボタンを押した後の流れ

github上でforkしてローカルから自分のlodgeにpushしたのがこちらになります。

https://github.com/hoshinotsuyoshi/lodge/tree/heroku_button

さっきREADMEに置いたherokuボタンを押します。
herokuボタンを押したあとは、普通にherokuボタンデプロイの流れです。

こんな画面。
App Nameを入力すると(必須ではない)その名前がサブドメインの名前(xxx.herokuapp.comのホスト名)になります。

![new](https://i.gyazo.com/c8b416da124962d952c94265e36d5b59.png)

下のほうでデプロイボタンを押します。環境変数を編集したりしてもいいですが、基本的にそのままで動くはずです。

![deploy](https://i.gyazo.com/bf7b70d490b750dcad55917dd0281102.png)

しばらく待ちます。assets:precompileとかmigrateとかが正常終了するとこうなります。

![](https://i.gyazo.com/195f6df196ffdee5be8be6818b803555.png)

「View it」を叩くと、デプロイされたlodgeのトップ画面に飛びます。
![](https://i.gyazo.com/a01cec51256387f50967199565fa00a9.png)

注意としては、無料といえどアドオンを使っていること、cleardb（mysqlアドオン）は無料だと5MBしか使えないので、そのままだとビジネス用途は難しいと思います。
sendgridも一日の送信数とかが割りと少なかったはず。

以上です。


## 参考

* http://qiita.com/tukiyo3/items/58d3599d848fc55eb604
* http://www.moongift.jp/2014/07/lodge-%E7%A4%BE%E5%86%85%E3%81%A7%E4%BD%BF%E3%81%88%E3%82%8B%E3%83%8A%E3%83%AC%E3%83%83%E3%82%B8%E5%85%B1%E6%9C%89%E3%82%B5%E3%83%BC%E3%83%93%E3%82%B9/
* http://blog.a-know.me/entry/2014/09/14/124323


## 以下、蛇足的メモ

## herokuにデプロイするために編集したこと詳細

#### .gitignore

herokuにデプロイするために、Gemfile.lockとconfig/database.ymlをignore対象から外します。

```diff
diff --git a/.gitignore b/.gitignore
index 5271928..710789e 100644
--- a/.gitignore
+++ b/.gitignore
@@ -23,9 +23,6 @@
 /log/*.log
 /tmp
 
-/config/database.yml
-
-/Gemfile.lock
 /vendor/bundle
 lodge_development
 lodge_test
@@ -40,4 +37,4 @@ public/uploads/
 .env
 
 # Mac finder artifacts
-.DS_Store
\ No newline at end of file
+.DS_Store
```

#### Gemfile

データベースのアダプタを自動判定している部分をmysqlに決めうちしてしまいます
(postgresはちょっと詳しくないので、、)

```diff
diff --git a/Gemfile b/Gemfile
index f861c18..848d4b2 100644
--- a/Gemfile
+++ b/Gemfile
@@ -96,30 +96,4 @@ group :test do
   gem 'launchy'
 end
 
-# Include database gems for the adapters found in the database
-# configuration file
-require 'erb'
-require 'yaml'
-database_file = File.join(File.dirname(__FILE__), "config/database.yml")
-if File.exist?(database_file)
-  database_config = YAML::load(ERB.new(IO.read(database_file)).result)
-  adapters = database_config.values.map {|c| c['adapter']}.compact.uniq
-  if adapters.any?
-    adapters.each do |adapter|
-      case adapter
-      when 'mysql2'
-        gem "mysql2", '~> 0.3'
-      when /postgresql/
-        gem "pg", '~> 0.17'
-      when /sqlite3/
-        gem "sqlite3", '~> 1.3'
-      else
-        warn("Unknown database adapter `#{adapter}` found in config/database.yml")
-      end
-    end
-  else
-    warn("No adapter found in config/database.yml, please configure it first")
-  end
-else
-  warn("Please configure your config/database.yml first")
-end
+gem 'mysql2'
```

#### Gemfile.lock

bundle install後に追加。

```diff
diff --git a/Gemfile.lock b/Gemfile.lock
new file mode 100644
index 0000000..a01e01e
--- /dev/null
+++ b/Gemfile.lock
@@ -0,0 +1,416 @@
+ (省略)
```

#### README.md

herokuボタンのドキュメントを参考に、ボタンを設置

```diff
diff --git a/README.md b/README.md
index 4246894..be73a8c 100644
--- a/README.md
+++ b/README.md
@@ -4,6 +4,8 @@ Lodge
 [![Coverage Status](https://coveralls.io/repos/lodge/lodge/badge.png)](https://coveralls.io/r/lodge/lodge)
 [![Code Climate](https://codeclimate.com/github/lodge/lodge/badges/gpa.svg)](https://codeclimate.com/github/lodge/lodge)
 
+[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)
+
 =====
 
 ## これは何？
```

#### app.json

README.mdに書かれている環境変数や、DBとSMTPのアドオンなどを設定します。

* ポイント
  * cleardbとsendgridはそれぞれmysqlとSMTPのherokuアドオンです（無料プラン）
  * 環境変数LODGE_DOMAINは新規登録時のメールアドレス存在確認時に、コールバックリンクとして利用されます。ドメイン名がわかっている場合は、herokuボタンを押した後に書き換えるといいと思います
  * GOOGLE_CLIENT_IDとGOOGLE_CLIENT_SECRETは、その認証方式を使わないようであれば、特に埋めなくても大丈夫でした

```diff
diff --git a/app.json b/app.json
new file mode 100644
index 0000000..71e5069
--- /dev/null
+++ b/app.json
@@ -0,0 +1,22 @@
+{
+  "addons": [
+    "cleardb",
+    "sendgrid"
+  ],
+  "env" : {
+    "LODGE_DOMAIN"              : "example.com",
+    "SECRET_KEY_BASE"           : "__some_random_string__",
+    "DEVISE_SECRET_KEY"         : "__some_random_string__",
+    "GOOGLE_CLIENT_ID"          : "FILL_THE_CLIENT_ID",
+    "GOOGLE_CLIENT_SECRET"      : "FILL_THE_CLIENT_SECRET",
+    "DELIVERY_METHOD"           : "smtp",
+    "MAIL_SENDER"               : "lodge@example.com",
+    "SMTP_PORT"                 : "587",
+    "SMTP_AUTH_METHOD"          : "plain",
+    "SMTP_ENABLE_STARTTLS_AUTO" : "true",
+    "LODGE_THEME"               : "lodge"
+  },
+  "scripts": {
+    "postdeploy": "bundle exec rake db:migrate"
+  }
+}
```

#### config/database.yml

* cleardb(mysqlアドオン)の設定をベタに書きます

```diff
diff --git a/config/database.yml b/config/database.yml
new file mode 100644
index 0000000..39ac335
--- /dev/null
+++ b/config/database.yml
@@ -0,0 +1,3 @@
+# mysql
+# in heroku, use CLEARDB_DATABASE_URL
+<% ENV['DATABASE_URL'] = ENV['CLEARDB_DATABASE_URL'].to_s.sub(/\Amysql/){'mysql2'} %>
diff --git a/config/environments/production.rb b/config/environments/production.rb
index 7aa2d7b..eaa333a 100644
--- a/config/environments/production.rb
+++ b/config/environments/production.rb
@@ -93,11 +93,11 @@ Rails.application.configure do
   # SMTPの指定
   config.action_mailer.delivery_method = ENV["DELIVERY_METHOD"].to_sym
   config.action_mailer.smtp_settings = {
-    :address              => ENV["SMTP_ADDRESS"],
+    :address              => 'smtp.sendgrid.net',
     :port                 => ENV["SMTP_PORT"],
     :domain               => ENV["LODGE_DOMAIN"],
-    :user_name            => ENV["SMTP_USERNAME"],
-    :password             => ENV["SMTP_PASSWORD"],
+    :user_name            => ENV["SENDGRID_USERNAME"],
+    :password             => ENV["SENDGRID_PASSWORD"],
     :authentication       => ENV["SMTP_AUTH_METHOD"].to_sym,
     :enable_starttls_auto => ENV["SMTP_ENABLE_STARTTLS_AUTO"],
   }
```

元ページ：

http://qiita.com/hoshino/items/e058339f1399baab87b0
