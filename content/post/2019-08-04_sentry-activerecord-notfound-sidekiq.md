+++
date = "2019-08-04T07:48:28+09:00"
draft = false
title = "sentry-ravenはデフォルトではActiveRecord::RecordNotFoundを通知してくれない"
slug = "sentry-activerecord-notfound-sidekiq"
tags = ["sidekiq","rails","sentry"]
image = "defimg/2.jpg"
+++

Sidekiqでエラーが起きてるっぽいにもかかわらず、sentryに通知されず、謎ですねみたいな現象がありました。

調べたところ、 

**`sentry-raven`はデフォルト設定では特定の例外を通知してくれない!!**

ということがわかりました。

`ActiveRecord::RecordNotFound`に気づきたい場合は、設定をいじる必要があります。

<!--more-->

### ドキュメント

ドキュメントの、[このへん](https://docs.sentry.io/clients/ruby/config/) に書かれていました。

> <img alt="" src="/images/sentry-raven-excluded_exceptions.png" width=600>


### 該当箇所のソース抜粋

以下の通り、`IGNORE_DEFAULT`という定数で例外名が列挙されており、`excluded_exceptions` で設定できるようになっています。

https://github.com/getsentry/raven-ruby/blob/v2.11.0/lib/raven/configuration.rb#L175-L185

```ruby
    IGNORE_DEFAULT = [
      'AbstractController::ActionNotFound',
      'ActionController::InvalidAuthenticityToken',
      'ActionController::RoutingError',
      'ActionController::UnknownAction',
      'ActiveRecord::RecordNotFound',
      'CGI::Session::CookieStore::TamperedWithCookie',
      'Mongoid::Errors::DocumentNotFound',
      'Sinatra::NotFound',
      'ActiveJob::DeserializationError'
    ].freeze
```

https://github.com/getsentry/raven-ruby/blob/v2.11.0/lib/raven/configuration.rb#L211

```ruby
      self.excluded_exceptions = IGNORE_DEFAULT.dup
```

<br>

## config/initializers/sentry.rb での設定例

ということで、`ActiveRecord::RecordNotFound` が通知されるようにするには、このようにすれば良いです。

```ruby
Raven.configure do |config|
  # ...普段の設定....

  config.excluded_exceptions -= ['ActiveRecord::RecordNotFound']
end
```

<br>

しかし、私の職場の場合は、webサーバ(puma)では今のままでもいいので、

**Sidekiqやrakeタスクでのみこの設定を有効にしたい**

という感じでした。

最善の方法かどうかはわかりませんが、`$PROGRAM_NAME`の内容を見て場合分けするようにしてみました。

```ruby
Raven.configure do |config|
  # ...普段の設定....

  # NOTE:
  # sentry-ravenのデフォルト設定により、特定の例外が通知無効になっているが
  # sidekiqやrakeタスクの場合は、RecordNotFoundはsentryに通知したい
  if %w(sidekiq rake).any? { |name| $PROGRAM_NAME.include? name }
    config.excluded_exceptions -= ['ActiveRecord::RecordNotFound']
  end
end
```

<br>

...これでうまく動いています! 🍻


<script type="text/javascript" src="/js/prism.js" async></script>

---

{{% pixela_access_counter "hoshinotsuyoshi/graphs/hblog-20190804-1" %}}
