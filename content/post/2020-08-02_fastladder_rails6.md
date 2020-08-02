+++
date = "2020-08-02T17:57:44+09:00"
draft = false
title = "手元のfastladderをrails 6にした"
slug = "fastladder_rails6"
tags = ["fastladder","rails"]
image = "images/sea-4478242_1280.jpg"
+++

手元のfastladderをrails 6にしました。


<!--more-->

一度 rails4.2.10 -> rails4.2.11に上げて、
その次のPRで rails4.2 -> rails5.0 -> rails6.0に上げてます。

* PR1 https://github.com/hoshinotsuyoshi/fastladder/pull/4/
* PR2 https://github.com/hoshinotsuyoshi/fastladder/pull/5

変更点とか、アップデートしたGemとか対処とかは以下のとおり。

* FactoryBotを5系に
* Controllerテストができなくなるので、rails-controller-testing gemの追加
* quiet-assets削除
* validate uniqueness....にcase_sensitive: trueを追加
* etc.


dropした・諦めた・なんとなく変えてしまったものは以下

* JS周りのテストを削除
* MySQL以外のデータベースアダプタのサポートを削除
* unicornじゃなくてpumaにした
* etc.

色々変えてますが、主なdiffは以下のとおり。

```diff

diff --git a/Gemfile b/Gemfile
index c0a47a5..f19bd64 100644
--- a/Gemfile
+++ b/Gemfile
@@ -1,5 +1,5 @@
 source 'https://rubygems.org'
-gem 'rails', '4.2.10'
+gem 'rails'
 
 # Include database gems for the adapters found in the database
 # configuration file or DATABASE_URL
@@ -7,48 +7,51 @@ require 'erb'
 require 'uri'
 require 'yaml'
 
-database_file = File.join(File.dirname(__FILE__), "config/database.yml")
-adapters = []
+# database_file = File.join(File.dirname(__FILE__), "config/database.yml")
+# adapters = []
+# 
+# if File.exist?(database_file)
+#   database_config = YAML::load(ERB.new(IO.read(database_file)).result)
+#   adapters += database_config.values.map {|conf| conf['adapter']}.compact.uniq
+# end
+#
+# if database_url = ENV['DATABASE_URL']
+#   adapters << URI.parse(database_url).scheme
+# end
+# 
+# if adapters.any?
+#   adapters.each do |adapter|
+#     case adapter
+#     when 'mysql2'     ; gem 'mysql2'
+#     when 'mysql'      ; gem 'mysql'
+#     when /postgres/   ; gem 'pg'
+#     when /sqlite3/    ; gem 'sqlite3'
+#     else
+#       warn("Unknown database adapter `#{adapter}` found in config/database.yml, use Gemfile.local to load your own database gems")
+#     end
+#   end
+# else
+#   warn("No adapter found in config/database.yml or DATABASE_URL, please configure it first -- fallback to pg")
+#   gem 'pg'
+# end
 
-if File.exist?(database_file)
-  database_config = YAML::load(ERB.new(IO.read(database_file)).result)
-  adapters += database_config.values.map {|conf| conf['adapter']}.compact.uniq
-end
-
-if database_url = ENV['DATABASE_URL']
-  adapters << URI.parse(database_url).scheme
-end
-
-if adapters.any?
-  adapters.each do |adapter|
-    case adapter
-    when 'mysql2'     ; gem 'mysql2'
-    when 'mysql'      ; gem 'mysql'
-    when /postgres/   ; gem 'pg'
-    when /sqlite3/    ; gem 'sqlite3'
-    else
-      warn("Unknown database adapter `#{adapter}` found in config/database.yml, use Gemfile.local to load your own database gems")
-    end
-  end
-else
-  warn("No adapter found in config/database.yml or DATABASE_URL, please configure it first -- fallback to pg")
-  gem 'pg'
-end
+# https://qiita.com/otsukishinsuke/items/f5ff336f63366c364909 0.5系は使えない
+# https://gitlab.com/gitlab-org/gitlab-foss/-/issues/37100 0.3系は使えない
+gem 'mysql2'
 
 gem 'addressable', require: 'addressable/uri'
-gem 'coffee-rails', '~> 4.1.0'
+gem 'coffee-rails'
 gem 'feed_searcher', '>= 0.0.6'
 gem 'feedjira'
 gem 'haml'
 gem 'i18n-js'
-gem 'jbuilder', '~> 2.0'
-gem 'jquery-rails'
+gem 'jbuilder'
 gem 'mini_magick'
 gem 'nokogiri'
-gem 'opml', git: 'https://github.com/fastladder/opml'
-gem 'sass-rails', '~> 5.0.0'
+gem 'opml', git: 'https://github.com/hoshinotsuyoshi/opml', branch: :relax_activesupport_dependency
+gem 'sassc-rails'
 gem 'settingslogic'
-gem 'uglifier', '>= 1.3.0'
+gem 'uglifier'
 
 if ENV['NEW_RELIC_LICENSE_KEY']
   gem 'newrelic_rpm'
@@ -62,16 +65,15 @@ group :development do
   gem 'annotate'
   gem 'pry-rails'
   gem 'pry-doc'
-  gem 'quiet_assets'
 end
 
 group :test do
   gem 'capybara'
   gem 'coveralls', require: false
   gem 'factory_bot_rails'
-  gem 'konacha'
   gem 'launchy'
   gem 'poltergeist'
+  gem 'rails-controller-testing'
   gem 'rspec-activemodel-mocks'
   gem 'rspec-rails'
   gem 'simplecov'
@@ -80,8 +82,3 @@ group :test do
   gem 'puma'
   gem 'webmock'
 end
-
-group :production do
-  gem 'rails_12factor'
-  gem 'unicorn'
-end
diff --git a/app/assets/config/manifest.js b/app/assets/config/manifest.js
new file mode 100644
index 0000000..b16e53d
--- /dev/null
+++ b/app/assets/config/manifest.js
@@ -0,0 +1,3 @@
+//= link_tree ../images
+//= link_directory ../javascripts .js
+//= link_directory ../stylesheets .css
diff --git a/app/controllers/api/feed_controller.rb b/app/controllers/api/feed_controller.rb
index efe5d4d..cd25c13 100644
--- a/app/controllers/api/feed_controller.rb
+++ b/app/controllers/api/feed_controller.rb
@@ -27,7 +27,7 @@ class Api::FeedController < ApplicationController
       else
         html = Fastladder.simple_fetch(feedlink)
         logger.debug html
-        unless feed = Feedjira::Feed.parse(html)
+        unless feed = Feedjira.parse(html)
           next
         end
         feeds << {
diff --git a/app/controllers/api_controller.rb b/app/controllers/api_controller.rb
index 41d70bc..ae27c33 100644
--- a/app/controllers/api_controller.rb
+++ b/app/controllers/api_controller.rb
@@ -43,7 +43,7 @@ class ApiController < ApplicationController
   def touch_all
     params[:subscribe_id].split(/\s*,\s*/).each do |id|
       if sub = @member.subscriptions.find_by(id: id)
-        sub.update_attributes(has_unread: false, viewed_on: DateTime.now)
+        sub.update(has_unread: false, viewed_on: DateTime.now)
       end
     end
     render_json_status(true)
@@ -53,7 +53,7 @@ class ApiController < ApplicationController
     timestamps = params[:timestamp].split(/\s*, \s*/).map { |t| t.to_i }
     params[:subscribe_id].split(/\s*,\s*/).each_with_index do |id, i|
       if sub = Subscription.find(id) and sub.member_id == @member.id and timestamps[i]
-        sub.update_attributes(has_unread: false, viewed_on: Time.at(timestamps[i] + 1))
+        sub.update(has_unread: false, viewed_on: Time.at(timestamps[i] + 1))
       end
     end
     render_json_status(true)
diff --git a/app/models/crawl_status.rb b/app/models/crawl_status.rb
index 0907f61..8c72ac4 100644
--- a/app/models/crawl_status.rb
+++ b/app/models/crawl_status.rb
@@ -26,7 +26,7 @@ class CrawlStatus < ActiveRecord::Base
     feed = nil
     CrawlStatus.transaction do
       if feed = Feed.crawlable.order("crawl_statuses.crawled_on").first
-        feed.crawl_status.update_attributes(status: Fastladder::Crawler::CRAWL_NOW, crawled_on: Time.now)
+        feed.crawl_status.update(status: Fastladder::Crawler::CRAWL_NOW, crawled_on: Time.now)
       end
     end
     feed
diff --git a/app/models/feed.rb b/app/models/feed.rb
index 37d17b3..9ade7fb 100644
--- a/app/models/feed.rb
+++ b/app/models/feed.rb
@@ -49,7 +49,7 @@ class Feed < ActiveRecord::Base
   end
 
   def self.initialize_from_uri(uri)
-    feed_dom = Feedjira::Feed.parse(Fastladder.simple_fetch(uri))
+    feed_dom = Feedjira.parse(Fastladder.simple_fetch(uri))
     return nil unless feed_dom
 
     self.new(
diff --git a/app/models/item.rb b/app/models/item.rb
index 057e667..6dbe8d8 100644
--- a/app/models/item.rb
+++ b/app/models/item.rb
@@ -21,7 +21,7 @@
 
 class Item < ActiveRecord::Base
   belongs_to :feed
-  validates :guid, presence: true, uniqueness: { scope: :feed_id }
+  validates :guid, presence: true, uniqueness: { scope: :feed_id, case_sensitive: true }
 
   before_validation :default_values
   before_save :create_digest, :fill_datetime
diff --git a/app/models/member.rb b/app/models/member.rb
index 269e0d2..058ada4 100644
--- a/app/models/member.rb
+++ b/app/models/member.rb
@@ -34,7 +34,7 @@ class Member < ActiveRecord::Base
   validates_confirmation_of :password, if: :password_required?
   validates_length_of :username, within: 3..40
   validates_uniqueness_of :username, case_sensitive: false
-  validates_uniqueness_of :auth_key, allow_nil: true
+  validates_uniqueness_of :auth_key, allow_nil: true, case_sensitive: true
   before_save :encrypt_password
 
   # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
diff --git a/config/application.rb b/config/application.rb
index 101f513..e35ecd0 100644
--- a/config/application.rb
+++ b/config/application.rb
@@ -22,8 +22,5 @@ module Fastladder
     # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
     # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
     # config.i18n.default_locale = :de
-
-    # Do not swallow errors in after_commit/after_rollback callbacks.
-    config.active_record.raise_in_transactional_callbacks = true
   end
 end
diff --git a/config/boot.rb b/config/boot.rb
index 6b750f0..30f5120 100644
--- a/config/boot.rb
+++ b/config/boot.rb
@@ -1,3 +1,3 @@
-ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)
+ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)
 
 require 'bundler/setup' # Set up gems listed in the Gemfile.
diff --git a/config/cable.yml b/config/cable.yml
new file mode 100644
index 0000000..0bbde6f
--- /dev/null
+++ b/config/cable.yml
@@ -0,0 +1,9 @@
+development:
+  adapter: async
+
+test:
+  adapter: async
+
+production:
+  adapter: redis
+  url: redis://localhost:6379/1
diff --git a/config/database.yml b/config/database.yml
new file mode 100644
index 0000000..94c5b70
--- /dev/null
+++ b/config/database.yml
@@ -0,0 +1,48 @@
+# MySQL.  Versions 4.1 and 5.0 are recommended.
+#
+# Install the MySQL driver:
+#   gem install mysql
+# On Mac OS X:
+#   sudo gem install mysql -- --with-mysql-dir=/usr/local/mysql
+# On Mac OS X Leopard:
+#   sudo env ARCHFLAGS="-arch i386" gem install mysql -- --with-mysql-config=/usr/local/mysql/bin/mysql_config
+#       This sets the ARCHFLAGS environment variable to your native architecture
+# On Windows:
+#   gem install mysql
+#       Choose the win32 build.
+#       Install MySQL and put its /bin directory on your path.
+#
+# And be sure to use new-style password hashing:
+#   http://dev.mysql.com/doc/refman/5.0/en/old-client.html
+development:
+  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
+  adapter: mysql2
+  encoding: utf8mb4
+  database: fastladder_development
+  username: root
+  password: root
+  host: db
+  # port: 3307
+
+# Warning: The database defined as 'test' will be erased and
+# re-generated from your development database when you run 'rake'.
+# Do not set this db to the same as development or production.
+test:
+  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
+  adapter: mysql2
+  encoding: utf8mb4
+  database: fastladder_test
+  username: root
+  password: root
+  host: db
+  # port: 3307
+
+production:
+  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
+  adapter: mysql2
+  encoding: utf8mb4
+  database: fastladder_production
+  username: root
+  password: root
+  host: db
+  # port: 3307
diff --git a/config/environments/development.rb b/config/environments/development.rb
index b55e214..e64889c 100644
--- a/config/environments/development.rb
+++ b/config/environments/development.rb
@@ -9,13 +9,28 @@ Rails.application.configure do
   # Do not eager load code on boot.
   config.eager_load = false
 
-  # Show full error reports and disable caching.
-  config.consider_all_requests_local       = true
-  config.action_controller.perform_caching = false
+  # Show full error reports.
+  config.consider_all_requests_local = true
+
+  # Enable/disable caching. By default caching is disabled.
+  if Rails.root.join('tmp/caching-dev.txt').exist?
+    config.action_controller.perform_caching = true
+
+    config.cache_store = :memory_store
+    config.public_file_server.headers = {
+      'Cache-Control' => 'public, max-age=172800'
+    }
+  else
+    config.action_controller.perform_caching = false
+
+    config.cache_store = :null_store
+  end
 
   # Don't care if the mailer can't send.
   config.action_mailer.raise_delivery_errors = false
 
+  config.action_mailer.perform_caching = false
+
   # Print deprecation notices to the Rails logger.
   config.active_support.deprecation = :log
 
@@ -27,15 +42,13 @@ Rails.application.configure do
   # number of complex assets.
   config.assets.debug = true
 
-  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
-  # yet still be able to expire them through the digest params.
-  config.assets.digest = true
-
-  # Adds additional error checking when serving assets at runtime.
-  # Checks for improperly declared sprockets dependencies.
-  # Raises helpful error messages.
-  config.assets.raise_runtime_errors = true
+  # Suppress logger output for asset requests.
+  config.assets.quiet = true
 
   # Raises error for missing translations
   # config.action_view.raise_on_missing_translations = true
+
+  # Use an evented file watcher to asynchronously detect changes in source code,
+  # routes, locales, etc. This feature depends on the listen gem.
+  # config.file_watcher = ActiveSupport::EventedFileUpdateChecker
 end
diff --git a/config/environments/production.rb b/config/environments/production.rb
index 2aa88a8..2296660 100644
--- a/config/environments/production.rb
+++ b/config/environments/production.rb
@@ -14,15 +14,9 @@ Rails.application.configure do
   config.consider_all_requests_local       = false
   config.action_controller.perform_caching = true
 
-  # Enable Rack::Cache to put a simple HTTP cache in front of your application
-  # Add `rack-cache` to your Gemfile before enabling this.
-  # For large-scale production use, consider using a caching reverse proxy like
-  # NGINX, varnish or squid.
-  # config.action_dispatch.rack_cache = true
-
   # Disable serving static files from the `/public` folder by default since
   # Apache or NGINX already handles this.
-  config.serve_static_files = ENV['RAILS_SERVE_STATIC_FILES'].present?
+  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?
 
   # Compress JavaScripts and CSS.
   config.assets.js_compressor = :uglifier
@@ -31,34 +25,37 @@ Rails.application.configure do
   # Do not fallback to assets pipeline if a precompiled asset is missed.
   config.assets.compile = false
 
-  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
-  # yet still be able to expire them through the digest params.
-  config.assets.digest = true
-
   # `config.assets.precompile` and `config.assets.version` have moved to config/initializers/assets.rb
 
+  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
+  # config.action_controller.asset_host = 'http://assets.example.com'
+
   # Specifies the header that your server uses for sending files.
   # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
   # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX
 
+  # Mount Action Cable outside main process or domain
+  # config.action_cable.mount_path = nil
+  # config.action_cable.url = 'wss://example.com/cable'
+  # config.action_cable.allowed_request_origins = [ 'http://example.com', /http:\/\/example.*/ ]
+
   # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
   # config.force_ssl = true
 
   # Use the lowest log level to ensure availability of diagnostic information
   # when problems arise.
-  config.log_level = :info
+  config.log_level = :debug
 
   # Prepend all log lines with the following tags.
-  # config.log_tags = [ :subdomain, :uuid ]
-
-  # Use a different logger for distributed setups.
-  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)
+  config.log_tags = [ :request_id ]
 
   # Use a different cache store in production.
   # config.cache_store = :mem_cache_store
 
-  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
-  # config.action_controller.asset_host = 'http://assets.example.com'
+  # Use a real queuing backend for Active Job (and separate queues per environment)
+  # config.active_job.queue_adapter     = :resque
+  # config.active_job.queue_name_prefix = "fastladder_#{Rails.env}"
+  config.action_mailer.perform_caching = false
 
   # Ignore bad email addresses and do not raise email delivery errors.
   # Set this to true and configure the email server for immediate delivery to raise delivery errors.
@@ -74,6 +71,16 @@ Rails.application.configure do
   # Use default logging formatter so that PID and timestamp are not suppressed.
   config.log_formatter = ::Logger::Formatter.new
 
+  # Use a different logger for distributed setups.
+  # require 'syslog/logger'
+  # config.logger = ActiveSupport::TaggedLogging.new(Syslog::Logger.new 'app-name')
+
+  if ENV["RAILS_LOG_TO_STDOUT"].present?
+    logger           = ActiveSupport::Logger.new(STDOUT)
+    logger.formatter = config.log_formatter
+    config.logger = ActiveSupport::TaggedLogging.new(logger)
+  end
+
   # Do not dump schema after migrations.
   config.active_record.dump_schema_after_migration = false
 end
diff --git a/config/environments/test.rb b/config/environments/test.rb
index feb35c3..831edd8 100644
--- a/config/environments/test.rb
+++ b/config/environments/test.rb
@@ -1,4 +1,3 @@
-require 'webmock/rspec'
 Rails.application.configure do
   # Settings specified here will take precedence over those in config/application.rb.
 
@@ -13,9 +12,11 @@ Rails.application.configure do
   # preloads Rails for running tests, you may have to set it to true.
   config.eager_load = false
 
-  # Configure static file server for tests with Cache-Control for performance.
-  config.serve_static_files   = true
-  config.static_cache_control = 'public, max-age=3600'
+  # Configure public file server for tests with Cache-Control for performance.
+  config.public_file_server.enabled = true
+  config.public_file_server.headers = {
+    'Cache-Control' => 'public, max-age=3600'
+  }
 
   # Show full error reports and disable caching.
   config.consider_all_requests_local       = true
@@ -26,15 +27,13 @@ Rails.application.configure do
 
   # Disable request forgery protection in test environment.
   config.action_controller.allow_forgery_protection = false
+  config.action_mailer.perform_caching = false
 
   # Tell Action Mailer not to deliver emails to the real world.
   # The :test delivery method accumulates sent emails in the
   # ActionMailer::Base.deliveries array.
   config.action_mailer.delivery_method = :test
 
-  # Randomize the order test cases are executed.
-  config.active_support.test_order = :random
-
   # Print deprecation notices to the stderr.
   config.active_support.deprecation = :stderr
 
diff --git a/config/initializers/application_controller_renderer.rb b/config/initializers/application_controller_renderer.rb
new file mode 100644
index 0000000..89d2efa
--- /dev/null
+++ b/config/initializers/application_controller_renderer.rb
@@ -0,0 +1,8 @@
+# Be sure to restart your server when you modify this file.
+
+# ActiveSupport::Reloader.to_prepare do
+#   ApplicationController.renderer.defaults.merge!(
+#     http_host: 'example.org',
+#     https: false
+#   )
+# end
diff --git a/config/initializers/cookies_serializer.rb b/config/initializers/cookies_serializer.rb
index 7f70458..5a6a32d 100644
--- a/config/initializers/cookies_serializer.rb
+++ b/config/initializers/cookies_serializer.rb
@@ -1,3 +1,5 @@
 # Be sure to restart your server when you modify this file.
 
+# Specify a serializer for the signed and encrypted cookie jars.
+# Valid options are :json, :marshal, and :hybrid.
 Rails.application.config.action_dispatch.cookies_serializer = :json
diff --git a/config/initializers/konacha.rb b/config/initializers/konacha.rb
deleted file mode 100644
index 4c235b6..0000000
--- a/config/initializers/konacha.rb
+++ /dev/null
@@ -1,8 +0,0 @@
-Konacha.configure do |config|
-  require 'capybara/poltergeist'
-  config.spec_dir = "spec/javascripts"
-  config.driver   = :poltergeist
-
-  Capybara.server = :puma
-end if defined?(Konacha)
-
diff --git a/config/initializers/new_framework_defaults.rb b/config/initializers/new_framework_defaults.rb
new file mode 100644
index 0000000..a2bfed3
--- /dev/null
+++ b/config/initializers/new_framework_defaults.rb
@@ -0,0 +1,20 @@
+# Be sure to restart your server when you modify this file.
+#
+# This file contains migration options to ease your Rails 5.0 upgrade.
+#
+# Once upgraded flip defaults one by one to migrate to the new default.
+#
+# Read the Guide for Upgrading Ruby on Rails for more info on each option.
+
+# Enable per-form CSRF tokens. Previous versions had false.
+Rails.application.config.action_controller.per_form_csrf_tokens = false
+
+# Enable origin-checking CSRF mitigation. Previous versions had false.
+Rails.application.config.action_controller.forgery_protection_origin_check = false
+
+# Make Ruby 2.4 preserve the timezone of the receiver when calling `to_time`.
+# Previous versions had false.
+ActiveSupport.to_time_preserves_timezone = false
+
+# Require `belongs_to` associations by default. Previous versions had false.
+Rails.application.config.active_record.belongs_to_required_by_default = false
diff --git a/config/initializers/wrap_parameters.rb b/config/initializers/wrap_parameters.rb
index 33725e9..bbfc396 100644
--- a/config/initializers/wrap_parameters.rb
+++ b/config/initializers/wrap_parameters.rb
@@ -5,10 +5,10 @@
 
 # Enable parameter wrapping for JSON. You can disable this by setting :format to an empty array.
 ActiveSupport.on_load(:action_controller) do
-  wrap_parameters format: [:json] if respond_to?(:wrap_parameters)
+  wrap_parameters format: [:json]
 end
 
 # To enable root element in JSON for ActiveRecord objects.
 # ActiveSupport.on_load(:active_record) do
-#  self.include_root_in_json = true
+#   self.include_root_in_json = true
 # end
diff --git a/config/puma.rb b/config/puma.rb
new file mode 100644
index 0000000..c7f311f
--- /dev/null
+++ b/config/puma.rb
@@ -0,0 +1,47 @@
+# Puma can serve each request in a thread from an internal thread pool.
+# The `threads` method setting takes two numbers a minimum and maximum.
+# Any libraries that use thread pools should be configured to match
+# the maximum value specified for Puma. Default is set to 5 threads for minimum
+# and maximum, this matches the default thread size of Active Record.
+#
+threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }.to_i
+threads threads_count, threads_count
+
+# Specifies the `port` that Puma will listen on to receive requests, default is 3000.
+#
+port        ENV.fetch("PORT") { 3000 }
+
+# Specifies the `environment` that Puma will run in.
+#
+environment ENV.fetch("RAILS_ENV") { "development" }
+
+# Specifies the number of `workers` to boot in clustered mode.
+# Workers are forked webserver processes. If using threads and workers together
+# the concurrency of the application would be max `threads` * `workers`.
+# Workers do not work on JRuby or Windows (both of which do not support
+# processes).
+#
+# workers ENV.fetch("WEB_CONCURRENCY") { 2 }
+
+# Use the `preload_app!` method when specifying a `workers` number.
+# This directive tells Puma to first boot the application and load code
+# before forking the application. This takes advantage of Copy On Write
+# process behavior so workers use less memory. If you use this option
+# you need to make sure to reconnect any threads in the `on_worker_boot`
+# block.
+#
+# preload_app!
+
+# The code in the `on_worker_boot` will be called if you are using
+# clustered mode by specifying a number of `workers`. After each worker
+# process is booted this block will be run, if you are using `preload_app!`
+# option you will want to use this block to reconnect to any threads
+# or connections that may have been created at application boot, Ruby
+# cannot share connections between processes.
+#
+# on_worker_boot do
+#   ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
+# end
+
+# Allow puma to be restarted by `rails restart` command.
+plugin :tmp_restart
diff --git a/config/secrets.yml b/config/secrets.yml
new file mode 100644
index 0000000..a7d2d8a
--- /dev/null
+++ b/config/secrets.yml
@@ -0,0 +1,8 @@
+# Do not keep production secrets in the repository,
+# instead read values from the environment.
+development:
+  secret_key_base: 6f989f7ab1c8e513e875ca044e44ad8c5cbffac5a64df7b875e6ee774a1d3bce8622d7a7389c9e6f59544ca173eb66be26d867cf3b9419eb42cfe9beec5108f9
+test:
+  secret_key_base: d2378123073112a12e1ce27795dc947cbbb77a8fa030adaa06a330f8c9eff1d9348fa823a333d25c16788d2d7ecea9b92dd27657197b97643edbbe7b3e68ff2d
+production:
+  secret_key_base: <%= ENV["SECRET_KEY_BASE"] %>
diff --git a/config/secrets.yml.sample b/config/secrets.yml.sample
deleted file mode 100644
index 1606c5b..0000000
--- a/config/secrets.yml.sample
+++ /dev/null
@@ -1,4 +0,0 @@
-# Do not keep production secrets in the repository,
-# instead read values from the environment.
-production:
-  secret_key_base: <%= ENV["SECRET_KEY_BASE"] %>
diff --git a/config/spring.rb b/config/spring.rb
new file mode 100644
index 0000000..c9119b4
--- /dev/null
+++ b/config/spring.rb
@@ -0,0 +1,6 @@
+%w(
+  .ruby-version
+  .rbenv-vars
+  tmp/restart.txt
+  tmp/caching-dev.txt
+).each { |path| Spring.watch(path) }
diff --git a/spec/controllers/about_controller_spec.rb b/spec/controllers/about_controller_spec.rb
index e8929a0..4fd2ba9 100644
--- a/spec/controllers/about_controller_spec.rb
+++ b/spec/controllers/about_controller_spec.rb
@@ -9,7 +9,7 @@ describe AboutController do
     context 'exists url' do
       before do
         allow(Feed).to receive(:find_by).with(feedlink: @feed.link) { @feed }
-        get :index, url: @feed.link
+        get :index, params: { url: @feed.link }
       end
 
       it 'assign feed' do
@@ -23,7 +23,7 @@ describe AboutController do
 
     context 'non-exists url' do
       before do
-        get :index, url: 'http://example.com/unknown'
+        get :index, params: { url: 'http://example.com/unknown' }
       end
 
       it 'return 404' do
diff --git a/spec/controllers/api/config_controller_spec.rb b/spec/controllers/api/config_controller_spec.rb
index a2a2622..ac6a9ce 100644
--- a/spec/controllers/api/config_controller_spec.rb
+++ b/spec/controllers/api/config_controller_spec.rb
@@ -9,7 +9,7 @@ describe Api::ConfigController do
   context 'logged in' do
     describe '.getter' do
       it 'renders json' do
-        get :getter, {}, { member_id: member.id }
+        get :getter, session: { member_id: member.id }
         expect(ActiveSupport::JSON.decode(response.body)).to include('use_wait' => '0', 'save_pin_limit' => Settings.save_pin_limit)
       end
     end
@@ -17,14 +17,14 @@ describe Api::ConfigController do
     describe '.setter' do
       it 'upadtes member' do
         expect {
-          post :setter, { use_wait: 42 }, { member_id: member.id }
+          post :setter, params: { use_wait: 42 }, session: { member_id: member.id }
         }.to change {
           Member.where(id: member.id).first.config_dump['use_wait'].to_i
         }.from(0).to(42)
       end
 
       it 'renders json' do
-        post :setter, { use_wait: 42 }, { member_id: member.id }
+        post :setter, params: { use_wait: 42 }, session: { member_id: member.id }
         expect(ActiveSupport::JSON.decode(response.body)).to include('use_wait' => '42')
       end
     end
@@ -33,20 +33,20 @@ describe Api::ConfigController do
   context 'not logged in' do
     describe '.getter' do
       it 'renders empty' do
-        get :getter, {}, {}
+        get :getter
         expect(response.body).to be_blank
       end
     end
 
     describe '.setter' do
       it 'renders empty' do
-        post :setter, { use_wait: 42 }, {}
+        post :setter, params: { use_wait: 42 }
         expect(response.body).to be_blank
       end
 
       it 'does not change value' do
         expect {
-          post :setter, { use_wait: 42 }, {}
+          post :setter, params: { use_wait: 42 }
         }.to_not change {
           Member.where(id: member.id).first.config_dump['use_wait']
         }
@@ -57,20 +57,20 @@ describe Api::ConfigController do
   context 'not logged in' do
     describe '.getter' do
       it 'renders empty' do
-        get :getter, {}, {}
+        get :getter
         expect(response.body).to be_blank
       end
     end
 
     describe '.setter' do
       it 'renders empty' do
-        post :setter, { use_wait: 42 }, {}
+        post :setter, params: { use_wait: 42 }
         expect(response.body).to be_blank
       end
 
       it 'does not change value' do
         expect {
-          post :setter, { use_wait: 42 }, {}
+          post :setter, params: { use_wait: 42 }
         }.to_not change {
           Member.where(id: member.id).first.config_dump['use_wait'].to_i
         }
diff --git a/spec/controllers/api/feed_controller_spec.rb b/spec/controllers/api/feed_controller_spec.rb
index 120f9df..d673772 100644
--- a/spec/controllers/api/feed_controller_spec.rb
+++ b/spec/controllers/api/feed_controller_spec.rb
@@ -14,103 +14,103 @@ describe Api::FeedController do
     end
 
     it 'renders json' do
-      post :discover, { url: @feed.feedlink }, { member_id: @member.id }
+      post :discover, params: { url: @feed.feedlink }, session: { member_id: @member.id }
       expect(response.body).to be_json
     end
 
     it 'renders error' do
-      post :discover, {}, { member_id: @member.id }
+      post :discover, session: { member_id: @member.id }
       expect(response.body).to be_json_error
     end
   end
 
   describe 'POST /subscribed' do
     it 'renders json' do
-      post :subscribed, { feedlink: @feed.feedlink, subscribe_id: @subscription.id }, { member_id: @member.id }
+      post :subscribed, params: { feedlink: @feed.feedlink, subscribe_id: @subscription.id }, session: { member_id: @member.id }
       expect(response.body).to be_json
     end
   end
 
   describe 'POST /subscribe' do
     it 'renders json' do
-      post :subscribe, { feedlink: @feed.feedlink }, { member_id: @member.id }
+      post :subscribe, params: { feedlink: @feed.feedlink }, session: { member_id: @member.id }
       expect(response.body).to be_json
     end
 
     it 'renders error' do
-      post :subscribe, { }, { member_id: @member.id }
+      post :subscribe, session: { member_id: @member.id }
       expect(response.body).to be_json_error
     end
   end
 
   describe 'POST /update' do
     it 'renders json' do
-      post :update, { subscribe_id: @subscription.id, folder_id: @folder.id }, { member_id: @member.id }
+      post :update, params: { subscribe_id: @subscription.id, folder_id: @folder.id }, session: { member_id: @member.id }
       expect(response.body).to be_json
     end
 
     it 'renders error' do
-      post :update, { folder_id: @folder.id }, { member_id: @member.id }
+      post :update, params: { folder_id: @folder.id }, session: { member_id: @member.id }
       expect(response.body).to be_json_error
     end
   end
 
   describe 'POST /unsubscribe' do
     it 'renders json' do
-      post :unsubscribe, { subscribe_id: @subscription.id, folder_id: @folder.id }, { member_id: @member.id }
+      post :unsubscribe, params: { subscribe_id: @subscription.id, folder_id: @folder.id }, session: { member_id: @member.id }
       expect(response.body).to be_json
     end
 
     it 'renders error' do
-      post :unsubscribe, { folder_id: @folder.id }, { member_id: @member.id }
+      post :unsubscribe, params: { folder_id: @folder.id }, session: { member_id: @member.id }
       expect(response.body).to be_json_error
     end
   end
 
   describe 'POST /set_rate' do
     it 'renders json' do
-      post :set_rate, { subscribe_id: @subscription.id, rate: 3 }, { member_id: @member.id }
+      post :set_rate, params: { subscribe_id: @subscription.id, rate: 3 }, session: { member_id: @member.id }
       expect(response.body).to be_json
     end
 
     it 'renders error' do
-      post :set_rate, {  rate: 3 }, { member_id: @member.id }
+      post :set_rate, params: {  rate: 3 }, session: { member_id: @member.id }
       expect(response.body).to be_json_error
     end
   end
 
   describe 'POST /move' do
     it 'renders json' do
-      post :move, { subscribe_id: @subscription.id, to: @folder.name }, { member_id: @member.id }
+      post :move, params: { subscribe_id: @subscription.id, to: @folder.name }, session: { member_id: @member.id }
       expect(response.body).to be_json
     end
 
     it 'renders error' do
-      post :move, { to: @folder.name }, { member_id: @member.id }
+      post :move, params: { to: @folder.name }, session: { member_id: @member.id }
       expect(response.body).to be_json_error
     end
   end
 
   describe 'POST /set_notify' do
     it 'renders json' do
-      post :set_notify, { subscribe_id: @subscription.id, ignore: '0' }, { member_id: @member.id }
+      post :set_notify, params: { subscribe_id: @subscription.id, ignore: '0' }, session: { member_id: @member.id }
       expect(response.body).to be_json
     end
 
     it 'renders error' do
-      post :set_notify, {  ignore: '0' }, { member_id: @member.id }
+      post :set_notify, params: {  ignore: '0' }, session: { member_id: @member.id }
       expect(response.body).to be_json_error
     end
   end
 
   describe 'POST /set_public' do
     it 'renders json' do
-      post :set_public, { subscribe_id: @subscription.id, public: '0' }, { member_id: @member.id }
+      post :set_public, params: { subscribe_id: @subscription.id, public: '0' }, session: { member_id: @member.id }
       expect(response.body).to be_json
     end
 
     it 'renders json' do
-      post :set_public, { public: '0' }, { member_id: @member.id }
+      post :set_public, params: { public: '0' }, session: { member_id: @member.id }
       expect(response.body).to be_json_error
     end
   end
@@ -119,20 +119,20 @@ describe Api::FeedController do
     it 'renders json' do
       allow(Feed).to receive(:find_by).with(feedlink: @feed.feedlink).and_return(@feed)
       expect(@feed).to receive(:fetch_favicon!)
-      post :fetch_favicon, { feedlink: @feed.feedlink }, { member_id: @member.id }
+      post :fetch_favicon, params: { feedlink: @feed.feedlink }, session: { member_id: @member.id }
       expect(response.body).to be_json
     end
   end
 
   context 'not login' do
     it 'renders blank page' do
-      post :discover, { url: @feed.feedlink }
+      post :discover, params: { url: @feed.feedlink }
       expect(response.body).to be_blank
     end
 
     it 'renders blank page' do
-      post :discover, { url: @feed.feedlink }
-      expect(response).to be_success
+      post :discover, params: { url: @feed.feedlink }
+      expect(response).to be_successful
     end
   end
 end
diff --git a/spec/controllers/api/folder_controller_spec.rb b/spec/controllers/api/folder_controller_spec.rb
index cc9d8b7..f8572c2 100644
--- a/spec/controllers/api/folder_controller_spec.rb
+++ b/spec/controllers/api/folder_controller_spec.rb
@@ -10,50 +10,50 @@ describe Api::FolderController do
   describe 'POST /create' do
     it 'creates new folder' do
       expect {
-        post :create, { name: '便利情報' }, { member_id: @member.id }
+        post :create, params: { name: '便利情報' }, session: { member_id: @member.id }
       }.to change {
         Folder.count
       }.by(1)
     end
 
     it 'renders json' do
-      post :create, { name: '便利情報' }, { member_id: @member.id }
+      post :create, params: { name: '便利情報' }, session: { member_id: @member.id }
       expect(response.body).to be_json
     end
 
     it 'renders error' do
-      post :create, { }, { member_id: @member.id }
+      post :create, session: { member_id: @member.id }
       expect(response.body).to be_json_error
     end
   end
 
   describe 'POST /delete' do
     it 'renders json' do
-      post :delete, { folder_id: @folder.id }, { member_id: @member.id }
+      post :delete, params: { folder_id: @folder.id }, session: { member_id: @member.id }
       expect(response.body).to be_json
     end
 
     it 'renders error' do
-      post :delete, { }, { member_id: @member.id }
+      post :delete, session: { member_id: @member.id }
       expect(response.body).to be_json_error
     end
   end
 
   describe 'POST /update' do
     it 'renders json' do
-      post :update, { folder_id: @folder.id, name: 'Life Hack' }, { member_id: @member.id }
+      post :update, params: { folder_id: @folder.id, name: 'Life Hack' }, session: { member_id: @member.id }
       expect(response.body).to be_json
     end
 
     it 'renders error' do
-      post :update, { }, { member_id: @member.id }
+      post :update, session: { member_id: @member.id }
       expect(response.body).to be_json_error
     end
   end
 
   context 'not logged in' do
     it 'renders blank' do
-      post :update, { }, { }
+      post :update
       expect(response.body).to be_blank
     end
   end
diff --git a/spec/controllers/api/pin_controller_spec.rb b/spec/controllers/api/pin_controller_spec.rb
index c67f0a9..157aeeb 100644
--- a/spec/controllers/api/pin_controller_spec.rb
+++ b/spec/controllers/api/pin_controller_spec.rb
@@ -13,42 +13,42 @@ describe Api::PinController do
   describe 'POST /all' do
     it 'renders json' do
       3.times.each { FactoryBot.create(:pin, member: @member) }
-      post :all, {}, { member_id: @member.id }
+      post :all, session: { member_id: @member.id }
       expect(response.body).to be_json
     end
 
     it 'renders purified link' do
       FactoryBot.create(:pin, member: @member, link: 'http://www.example.com/get?x=1&y=2')
-      post :all, {}, { member_id: @member.id }
+      post :all, session: { member_id: @member.id }
       expect(JSON.parse(response.body).last['link']).to include('&amp;')
     end
   end
 
   describe 'POST /add' do
     it 'renders json' do
-      post :add, { link: 'http://la.ma.la/blog/diary_200810292006.htm', title: '近況' }, { member_id: @member.id }
+      post :add, params: { link: 'http://la.ma.la/blog/diary_200810292006.htm', title: '近況' }, session: { member_id: @member.id }
       expect(response.body).to be_json
     end
 
     it 'renders error' do
-      post :add, {}, { member_id: @member.id }
+      post :add, session: { member_id: @member.id }
       expect(response.body).to eq(error)
     end
   end
 
   describe 'POST /remove' do
     it 'renders json' do
-      post :remove, { link: 'http://la.ma.la/blog/diary_200810292006.htm' }, { member_id: @member.id }
+      post :remove, params: { link: 'http://la.ma.la/blog/diary_200810292006.htm' }, session: { member_id: @member.id }
       expect(response.body).to be_json
     end
 
     it 'renders error' do
-      post :remove, {}, { member_id: @member.id }
+      post :remove, session: { member_id: @member.id }
       expect(response.body).to be_json_error
     end
     context "pin not found" do
       it 'return errorcode' do
-        post :remove, { link: 'http://la.ma.la/blog/diary_200810292006.htm' }, { member_id: @member.id }
+        post :remove, params: { link: 'http://la.ma.la/blog/diary_200810292006.htm' }, session: { member_id: @member.id }
         expect(JSON.parse(response.body)).to include("ErrorCode" => Api::PinController::ErrorCode::NOT_FOUND)
       end
     end
@@ -56,7 +56,7 @@ describe Api::PinController do
       let(:link) { 'http://la.ma.la/blog/diary_200810292006.htm' }
       before { FactoryBot.create(:pin, member: @member, link: link) }
       it 'return success' do
-        post :remove, { link: link }, { member_id: @member.id }
+        post :remove, params: { link: link }, session: { member_id: @member.id }
         expect(JSON.parse(response.body)).to include("isSuccess" => true)
       end
     end
@@ -65,19 +65,19 @@ describe Api::PinController do
   describe 'POST /clear' do
     before { FactoryBot.create(:pin, member: @member) }
     it 'renders json' do
-      post :clear, {}, { member_id: @member.id }
+      post :clear, session: { member_id: @member.id }
       expect(response.body).to be_json
     end
     it 'delete all pins' do
       expect {
-        post :clear, {}, { member_id: @member.id }
+        post :clear, session: { member_id: @member.id }
       }.to change{ @member.pins.count }.from(1).to(0)
     end
   end
 
   context 'not logged in' do
     it 'renders blank' do
-      post :clear, {}, {}
+      post :clear
       expect(response.body).to be_blank
     end
   end
diff --git a/spec/controllers/api_controller_spec.rb b/spec/controllers/api_controller_spec.rb
index d796ca5..7d404dc 100644
--- a/spec/controllers/api_controller_spec.rb
+++ b/spec/controllers/api_controller_spec.rb
@@ -14,15 +14,15 @@ describe ApiController do
       @items = Array.new(3) { FactoryBot.create(:item, feed: @feed) }
     }
     it 'renders json' do
-      get :all, { subscribe_id: @subscription.id }, { member_id: @member.id }
+      get :all, params: { subscribe_id: @subscription.id }, session: { member_id: @member.id }
       expect(response.body).to be_json
     end
     it 'limit works' do
-      get :all, { subscribe_id: @subscription.id, limit: 2 }, { member_id: @member.id }
+      get :all, params: { subscribe_id: @subscription.id, limit: 2 }, session: { member_id: @member.id }
       expect(JSON.parse(response.body)["items"].size).to eq(2)
     end
     it 'offset works' do
-      get :all, { subscribe_id: @subscription.id, offset: 1 }, { member_id: @member.id }
+      get :all, params: { subscribe_id: @subscription.id, offset: 1 }, session: { member_id: @member.id }
       expect(JSON.parse(response.body)["items"][0]).to include("id" => @items[1].id)
       expect(JSON.parse(response.body)["items"][1]).to include("id" => @items[0].id)
     end
@@ -31,31 +31,31 @@ describe ApiController do
       feed = FactoryBot.create :feed
       item = FactoryBot.create :item, feed: feed, link: 'http://www.example.com/get?x=1&y=2'
       subscription = FactoryBot.create :subscription, feed: feed, member: @member
-      get :all, { subscribe_id: subscription.id }, { member_id: @member.id }
+      get :all, params: { subscribe_id: subscription.id }, session: { member_id: @member.id }
       expect(JSON.parse(response.body)['items'].first['link']).to include('&amp;')
     end
   end
 
   describe 'POST /touch_all' do
     it 'renders json' do
-      post :touch_all, { subscribe_id: @subscription.id }, { member_id: @member.id }
+      post :touch_all, params: { subscribe_id: @subscription.id }, session: { member_id: @member.id }
       expect(response.body).to be_json
     end
 
     it 'reders error' do
-      post :touch_all, {}, { member_id: @member.id }
+      post :touch_all, session: { member_id: @member.id }
       expect(response.body).to be_json_error
     end
   end
 
   describe 'POST /touch' do
     it 'renders json' do
-      post :touch, { timestamp: Time.now.to_i, subscribe_id: @subscription.id }, { member_id: @member.id }
+      post :touch, params: { timestamp: Time.now.to_i, subscribe_id: @subscription.id }, session: { member_id: @member.id }
       expect(response.body).to be_json
     end
 
     it 'renders error' do
-      post :touch, {}, { member_id: @member.id }
+      post :touch, session: { member_id: @member.id }
       expect(response.body).to be_json
     end
   end
@@ -74,7 +74,7 @@ describe ApiController do
     end
 
     it 'renders json' do
-      post :crawl, { subscribe_id: @subscription.id }, { member_id: @member.id }
+      post :crawl, params: { subscribe_id: @subscription.id }, session: { member_id: @member.id }
       expect(response.body).to be_json
     end
   end
@@ -85,13 +85,13 @@ describe ApiController do
     }
     context 'default' do
       it "has read and unread subscriptions" do
-        get :subs, {}, { member_id: @member.id }
+        get :subs, session: { member_id: @member.id }
         expect(JSON.parse(response.body).count).to eq(2)
       end
     end
     context 'with unread' do
       it "has only unread subscriptions" do
-        get :subs, {unread: 1}, { member_id: @member.id }
+        get :subs, params: {unread: 1}, session: { member_id: @member.id }
         expect(JSON.parse(response.body).count).to eq(1)
       end
     end
@@ -99,38 +99,38 @@ describe ApiController do
 
   describe 'GET /lite_subs' do
     it 'renders json' do
-      get :lite_subs, {}, { member_id: @member.id }
+      get :lite_subs, session: { member_id: @member.id }
       expect(response.body).to be_json
     end
   end
 
   describe 'GET /item_count' do
     it 'renders json' do
-      get :item_count, { since: @item.stored_on - 1.second }, { member_id: @member.id }
+      get :item_count, params: { since: @item.stored_on - 1.second }, session: { member_id: @member.id }
       expect(response.body.to_i).to eq(1)
     end
 
     it 'renders error' do
-      get :item_count, {}, { member_id: @member.id }
+      get :item_count, session: { member_id: @member.id }
       expect(response.body).to be_json_error
     end
   end
 
   describe 'GET /unread_count' do
     it 'renders json' do
-      get :unread_count, { since: @item.stored_on }, { member_id: @member.id }
+      get :unread_count, params: { since: @item.stored_on }, session: { member_id: @member.id }
       expect(response.body.to_i).to eq(0)
     end
 
     it 'renders error' do
-      get :unread_count, {}, { member_id: @member.id }
+      get :unread_count, session: { member_id: @member.id }
       expect(response.body).to be_json_error
     end
   end
 
   context 'not logged in' do
     it 'renders blank' do
-      get :subs, {}, {}
+      get :subs
       expect(response.body).to be_blank
     end
   end
diff --git a/spec/controllers/application_controller_spec.rb b/spec/controllers/application_controller_spec.rb
index 2e5980a..847a84b 100644
--- a/spec/controllers/application_controller_spec.rb
+++ b/spec/controllers/application_controller_spec.rb
@@ -15,8 +15,8 @@ describe ApplicationController do
     context 'Member exists' do
       context 'session[:member_id] is given' do
         it 'renders 200' do
-          get :index, { }, { member_id: member.id }
-          expect(response).to be_success
+          get :index, session: { member_id: member.id }
+          expect(response).to be_successful
         end
       end
 
@@ -26,15 +26,15 @@ describe ApplicationController do
         end
 
         it 'renders 200' do
-          get :index, { auth_key: member.auth_key }
-          expect(response).to be_success
+          get :index, params: { auth_key: member.auth_key }
+          expect(response).to be_successful
         end
       end
     end
 
     context 'Member not exists' do
       it 'redirects to login_path' do
-        get :index, { }, { }
+        get :index
         expect(response).to redirect_to(login_path)
       end
     end
@@ -51,14 +51,14 @@ describe ApplicationController do
 
     context 'Member exists' do
       it 'assigns @member' do
-        get :index, { }, { member_id: member.id }
+        get :index, session: { member_id: member.id }
         expect(assigns(:member)).to_not be_nil
       end
     end
 
     context 'Member not exists' do
       it 'not assigns @member' do
-        get :index, { }, { }
+        get :index
         expect(assigns(:member)).to be_nil
       end
     end
diff --git a/spec/controllers/favicon_controller_spec.rb b/spec/controllers/favicon_controller_spec.rb
index 4403e05..d32e10a 100644
--- a/spec/controllers/favicon_controller_spec.rb
+++ b/spec/controllers/favicon_controller_spec.rb
@@ -15,7 +15,7 @@ describe FaviconController do
       expect(controller).to receive(:send_data).with(anything, image_header) {
         @controller.head 200
       }
-      get :get, feed: @feed.link
+      get :get, params: { feed: @feed.link }
     end
   end
 end
diff --git a/spec/controllers/import_controller_spec.rb b/spec/controllers/import_controller_spec.rb
index 4e7218d..6b0c514 100644
--- a/spec/controllers/import_controller_spec.rb
+++ b/spec/controllers/import_controller_spec.rb
@@ -8,17 +8,17 @@ describe ImportController do
   describe 'POST /import' do
     it "fetch url" do
       expect(Fastladder).to receive(:simple_fetch).with('http://example.com') { '<opml/>' }
-      post :fetch, { url: 'http://example.com' }, { member_id: @member.id }
+      post :fetch, params: { url: 'http://example.com' }, session: { member_id: @member.id }
     end
 
     context "assigns" do
       include_context(:use_stub_opml)
       it "assigns folder" do
-        post :fetch, { url: 'http://example.com' }, { member_id: @member.id }
+        post :fetch, params: { url: 'http://example.com' }, session: { member_id: @member.id }
         expect(assigns[:folders].keys).to include("Subscriptions")
       end
       it "assigns item" do
-        post :fetch, { url: 'http://example.com' }, { member_id: @member.id }
+        post :fetch, params: { url: 'http://example.com' }, session: { member_id: @member.id }
         item = assigns[:folders]["Subscriptions"][0]
         expect(item).to include(title: "Recent Commits to fastladder:master")
         expect(item).to include(link: "https://github.com/fastladder/fastladder/commits/master")
diff --git a/spec/controllers/members_controller_spec.rb b/spec/controllers/members_controller_spec.rb
index 7d9fa6e..0235503 100644
--- a/spec/controllers/members_controller_spec.rb
+++ b/spec/controllers/members_controller_spec.rb
@@ -19,7 +19,7 @@ describe MembersController do
   describe 'GET /new' do
     it 'renders the new template' do
       get :new
-      expect(response).to be_success
+      expect(response).to be_successful
       expect(response).to render_template('new')
     end
   end
@@ -27,14 +27,14 @@ describe MembersController do
   describe 'POST /create'do
     it 'creates new member' do
       expect {
-        post :create, valid_params, valid_sessions
+        post :create, params: valid_params, session: valid_sessions
       }.to change {
         Member.count
       }.by(1)
     end
 
     it 'redirects to /' do
-      post :create, valid_params, valid_sessions
+      post :create, params: valid_params, session: valid_sessions
       expect(response).to redirect_to('/')
     end
   end
diff --git a/spec/controllers/rpc_controller_spec.rb b/spec/controllers/rpc_controller_spec.rb
index a1c524b..fb11fd7 100644
--- a/spec/controllers/rpc_controller_spec.rb
+++ b/spec/controllers/rpc_controller_spec.rb
@@ -13,13 +13,13 @@ describe RpcController do
     let(:params) { FactoryBot.attributes_for(:item) }
 
     it 'renders json' do
-      post :update_feed, { api_key: member.auth_key, json: params.to_json }
+      post :update_feed, params: { api_key: member.auth_key, json: params.to_json }
       expect(response.body).to be_json
     end
 
     it 'creates new item' do
       expect {
-        post :update_feed, { api_key: member.auth_key, json: params.to_json }
+        post :update_feed, params: { api_key: member.auth_key, json: params.to_json }
       }.to change {
         Item.count
       }.by(1)
@@ -29,7 +29,7 @@ describe RpcController do
       let(:params){FactoryBot.attributes_for(:item).slice(:link, :title, :body, :author, :category, :published_date).merge( feedtitle: 'malamalamala', api_key: member.auth_key, feedlink: 'http://ma.la')}
       it 'creates new item' do
         expect {
-          post :update_feed, { api_key: member.auth_key, json: params.to_json }
+          post :update_feed, params: { api_key: member.auth_key, json: params.to_json }
         }.to change {
           Item.count
         }.by(1)
@@ -40,7 +40,7 @@ describe RpcController do
       let(:params) { FactoryBot.attributes_for(:item).slice(:link, :title, :body, :author, :category, :published_date) }
       it 'creates new item' do
         expect {
-          post :update_feed, { api_key: member.auth_key, json: params.to_json }
+          post :update_feed, params: { api_key: member.auth_key, json: params.to_json }
         }.to change {
           Item.count
         }.by(1)
@@ -51,7 +51,7 @@ describe RpcController do
       let(:params) { FactoryBot.attributes_for(:item).slice(:link, :title, :body, :author, :category, :published_date).merge( feedtitle: 'malamalamala', feedlink: 'http://ma.la') }
       it 'creates new item' do
         expect {
-          post :update_feed, { api_key: member.auth_key, json: params.to_json }
+          post :update_feed, params: { api_key: member.auth_key, json: params.to_json }
         }.to change {
           Item.count
         }.by(1)
@@ -63,7 +63,7 @@ describe RpcController do
 
       it 'creates a new item with guid == link' do
         expect {
-          post :update_feed, { api_key: member.auth_key, json: params.to_json }
+          post :update_feed, params: { api_key: member.auth_key, json: params.to_json }
         }.to change {
           Item.find_by(guid: params[:link]).nil?
         }.from(true).to(false)
diff --git a/spec/controllers/sessions_controller_spec.rb b/spec/controllers/sessions_controller_spec.rb
index a6b2945..b468cec 100644
--- a/spec/controllers/sessions_controller_spec.rb
+++ b/spec/controllers/sessions_controller_spec.rb
@@ -22,7 +22,7 @@ describe SessionsController do
 
       it do
         get 'new'
-        expect(response).to be_success
+        expect(response).to be_successful
       end
     end
   end
@@ -30,7 +30,7 @@ describe SessionsController do
   describe "POST 'create'" do
     context "when authenticate successfully" do
       it "should redirect to root path" do
-        post :create, { username: member.username, password: member.password }
+        post :create, params: { username: member.username, password: member.password }
         expect(response).to redirect_to root_path
         expect(flash[:notice]).not_to be_nil
       end
@@ -38,7 +38,7 @@ describe SessionsController do
 
     context "when authenticate failed" do
       it "should re-render new page" do
-        post :create, { username: "bogus_username", password: "bogus_password" }
+        post :create, params: { username: "bogus_username", password: "bogus_password" }
         expect(response).to render_template("new")
         expect(flash[:alert]).not_to be_nil
       end
diff --git a/spec/controllers/subscribe_controller_spec.rb b/spec/controllers/subscribe_controller_spec.rb
index ce8e4c8..737d29f 100644
--- a/spec/controllers/subscribe_controller_spec.rb
+++ b/spec/controllers/subscribe_controller_spec.rb
@@ -8,7 +8,7 @@ describe SubscribeController do
   describe 'GET /confirm' do
     it "should search url by FeedSearcher" do
       expect(FeedSearcher).to receive(:search).with('http://example.com') { [] }
-      get :confirm, { url: 'http://example.com' }, { member_id: @member.id }
+      get :confirm, params: { url: 'http://example.com' }, session: { member_id: @member.id }
     end
   end
 end
diff --git a/spec/controllers/user_controller_spec.rb b/spec/controllers/user_controller_spec.rb
index eb871ba..182907e 100644
--- a/spec/controllers/user_controller_spec.rb
+++ b/spec/controllers/user_controller_spec.rb
@@ -16,25 +16,25 @@ describe UserController do
 
   describe 'GET /' do
     it 'renders the index template' do
-      get :index, login_name: member.username
-      expect(response).to be_success
+      get :index, params: { login_name: member.username }
+      expect(response).to be_successful
       expect(response).to render_template('index')
     end
 
     it 'renders rss' do
       request.accept = rss_mime_type
-      get :index, login_name: member.username
-      expect(response).to be_success
+      get :index, params: { login_name: member.username }
+      expect(response).to be_successful
       expect(response).to render_template('index')
-      expect(response.content_type).to eq(rss_mime_type)
+      expect(response.media_type).to eq(rss_mime_type)
     end
 
     it 'renders opml' do
       request.accept = opml_mime_type
-      get :index, login_name: member.username
-      expect(response).to be_success
+      get :index, params: { login_name: member.username }
+      expect(response).to be_successful
       expect(response).to render_template('index')
-      expect(response.content_type).to eq(opml_mime_type)
+      expect(response.media_type).to eq(opml_mime_type)
     end
   end
 end
diff --git a/spec/factories/feeds.rb b/spec/factories/feeds.rb
index 4d8676d..b1906da 100644
--- a/spec/factories/feeds.rb
+++ b/spec/factories/feeds.rb
@@ -6,21 +6,21 @@ FactoryBot.define do
 
   factory :feed do
     feedlink { FactoryBot.generate(:feed_feedlink_seq) }
-    link 'http://la.ma.la/blog/'
-    title '最速インターフェース研究会'
-    description 'はてな使ったら負けかなと思っている'
+    link { 'http://la.ma.la/blog/' }
+    title { '最速インターフェース研究会' }
+    description { 'はてな使ったら負けかなと思っている' }
   end
 
   factory :crawl_ok_feed, parent: :feed do
     crawl_status { FactoryBot.create(:crawl_status, status: Fastladder::Crawler::CRAWL_OK) }
-    subscribers_count 1
+    subscribers_count { 1 }
   end
 
   factory :feed_without_description, parent: :feed do
-    description nil
+    description { nil }
   end
 
   factory :feed_without_title, parent: :feed do
-    title nil
+    title { nil }
   end
 end
diff --git a/spec/factories/folders.rb b/spec/factories/folders.rb
index b247f66..f7ec987 100644
--- a/spec/factories/folders.rb
+++ b/spec/factories/folders.rb
@@ -3,6 +3,6 @@
 
 FactoryBot.define do
   factory :folder do
-    name 'ライフハック'
+    name { 'ライフハック' }
   end
 end
diff --git a/spec/factories/items.rb b/spec/factories/items.rb
index 65daa56..710eb2d 100644
--- a/spec/factories/items.rb
+++ b/spec/factories/items.rb
@@ -7,14 +7,14 @@ FactoryBot.define do
 
   factory :item do
     link { FactoryBot.generate(:item_link_seq) }
-    title '最速インターフェース研究会 :: 近況'
-    body '観光目的で7ヶ月ほど京都旅行に行っていた。<br>祇園祭楽しかったですね。'
-    author 'mala'
-    category '???'
-    enclosure nil
-    enclosure_type nil
-    digest nil
-    version 1
+    title { '最速インターフェース研究会 :: 近況' }
+    body { '観光目的で7ヶ月ほど京都旅行に行っていた。<br>祇園祭楽しかったですね。' }
+    author { 'mala' }
+    category { '???' }
+    enclosure { nil }
+    enclosure_type { nil }
+    digest { nil }
+    version { 1 }
     guid { FactoryBot.generate(:item_guid_seq) }
     stored_on   { Time.now }
     modified_on { Time.now }
@@ -23,14 +23,14 @@ FactoryBot.define do
   end
 
   factory :item_without_title, parent: :item do
-    title nil
+    title { nil }
   end
 
   factory :item_without_guid, parent: :item do
-    guid nil
+    guid { nil }
   end
 
   factory :item_has_fixed_guid, parent: :item do
-    guid "guid"
+    guid { "guid" }
   end
 end
diff --git a/spec/factories/members.rb b/spec/factories/members.rb
index 116e7d1..87769a4 100644
--- a/spec/factories/members.rb
+++ b/spec/factories/members.rb
@@ -2,7 +2,7 @@
 
 FactoryBot.define do
   factory :member do
-    username 'bulkneets'
-    email 'bulkneets@ma.la'
+    username { 'bulkneets' }
+    email { 'bulkneets@ma.la' }
   end
 end
diff --git a/spec/factories/pins.rb b/spec/factories/pins.rb
index 59e7637..f576476 100644
--- a/spec/factories/pins.rb
+++ b/spec/factories/pins.rb
@@ -6,6 +6,6 @@ FactoryBot.define do
 
   factory :pin do
     link { generate :pin_link_seq }
-    title 'title'
+    title { 'title' }
   end
 end
diff --git a/spec/factories/subscriptions.rb b/spec/factories/subscriptions.rb
index fe23214..2681649 100644
--- a/spec/factories/subscriptions.rb
+++ b/spec/factories/subscriptions.rb
@@ -7,7 +7,7 @@ FactoryBot.define do
 
   factory :unread_subscription, parent: :subscription do
     feed { FactoryBot.create(:feed, items: [FactoryBot.create(:item, stored_on: 1.hour.ago)]) }
-    has_unread true
+    has_unread { true }
     viewed_on { 2.hour.ago }
   end
 end
diff --git a/spec/lib/fastladder/crawler_spec.rb b/spec/lib/fastladder/crawler_spec.rb
index 6d3e92d..edcd71a 100644
--- a/spec/lib/fastladder/crawler_spec.rb
+++ b/spec/lib/fastladder/crawler_spec.rb
@@ -62,7 +62,7 @@ describe 'Fastladder::Crawler' do
 
   describe '#new_items_count' do
     let(:items) { crawler.send(:build_items, feed, parsed) }
-    let(:parsed) { Feedjira::Feed.parse(source.body) }
+    let(:parsed) { Feedjira.parse(source.body) }
     let(:source) { double('HTTP response', body: atom_body) }
     let(:atom_body) { File.read(File.expand_path('../../fixtures/github.private.atom', __dir__)) }
 
diff --git a/spec/requests/favicon_spec.rb b/spec/requests/favicon_spec.rb
index bbc96dd..8aca331 100644
--- a/spec/requests/favicon_spec.rb
+++ b/spec/requests/favicon_spec.rb
@@ -6,9 +6,9 @@ describe 'favicon' do
 
     it 'returns favicon' do
       expect(Feed).to receive(:find_by).with(feedlink: feed.link).and_call_original
-      get "/favicon/#{feed.link}"
+      get "/favicon/#{feed.link}", params: {}, headers: {}
       expect(response).to be_ok
-      expect(response.content_type).to eq('image/png')
+      expect(response.media_type).to eq('image/png')
     end
   end
 end
diff --git a/spec/spec_helper.rb b/spec/spec_helper.rb
index f7e8163..c440c00 100644
--- a/spec/spec_helper.rb
+++ b/spec/spec_helper.rb
@@ -14,6 +14,7 @@ end
 ENV["RAILS_ENV"] ||= 'test'
 
 require File.expand_path("../../config/environment", __FILE__)
+require 'action_view/test_case'
 require 'rspec/rails'
 require 'capybara/rspec'
 require 'capybara/rails'
```

### ✎まとめ

特になし

<script type="text/javascript" src="/js/prism.js" async></script>

----

photo by https://pixabay.com/photos/sea-ladder-white-sandy-beach-sand-4478242/
