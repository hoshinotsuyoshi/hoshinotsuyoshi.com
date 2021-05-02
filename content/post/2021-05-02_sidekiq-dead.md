+++
date = "2021-05-02T19:33:21+09:00"
draft = false
title = "Sidekiqで例外発生時にSentry通知したり、リトライが全て失敗した時だけSentry通知したりする"
slug = "sidekiq-dead"
tags = ["sentry","sidekiq"]
image = "defimg/1.jpg"
+++

SidekiqでのSentry通知/リトライの設定方法の話と、「普段は無視するけどリトライが全て失敗した時だけSentry通知したい」といった設定の方法の話をします。

<!--more-->

### はじめに

* Sidekiqは6.2
* Rails(だけどActiveJobは使わない)
* sentryのgemは`sentry-ruby`

の前提です。

(なお、Sidekiqは[wikiがとっても充実している](https://github.com/mperham/sidekiq/wiki)ので、たいていのことはそこを見ればわかります。
とくに今回のエントリはwikiの[エラーハンドリング](https://github.com/mperham/sidekiq/wiki/Error-Handling) の内容が参考になります。)

### 1. Sentryに通知し、リトライもしたい場合

このケースでは、rescueせずに、単に例外を投げっぱなしにすれば良いです。

```ruby
class FooWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5 # 設定しないとデフォルトは25。

  class Error < ::StandardError; end

  def perform(arg)
    # Errorが起きるかもしれないことを何かする
  end
end
```

### 2. Sentryに通知し、リトライはしたくない場合

このケースでは、`1.` と同様、例外を投げっぱなしにしつつ、リトライしない設定、つまり`sidekiq_options retry: 0` または `sidekiq_options retry: false` を設定すればオーケー。

```ruby
class FooWorker
  include Sidekiq::Worker
  sidekiq_options retry: 0

  # 以下同じ...
```

### 3. Sentryに通知せず、リトライはしたい場合

このケースでは、`1.` の設定に加え、 `excluded_exceptions` を設定すればオーケーです。

```ruby
# config/initializers/sentry.rb とかで。
Sentry.init do |config|
  config.excluded_exceptions += [
    'FooWorker::Error', # 追加
  ]
end
```

### 4. Sentryに通知せず、リトライもしない場合

このケースでは、`3.` の設定に加え、 リトライしない設定、つまり`sidekiq_options retry: 0` または `sidekiq_options retry: false` を設定すればオーケー。

(冗長なのでコード省略)


### 5. Sentryに通知せず、リトライはするが、リトライが全て失敗した時だけSentryに通知したい場合


ワーカーで非同期処理をやっていると「普段は無視するけどリトライが全て失敗した時だけSentry通知したい」というケースがよくあると思います。

たとえば外部のAPIを叩く処理で、そのAPIが調子悪い時はSidekiqにリトライを任せるが、ある程度リトライしてダメならdeadセットに送ってしまって、あとで手動対応したい、というような場合です。


このケースでは、`3.` の設定に加え、Sidekiqの `death_handlers` をセットし、そのブロックの中でSentryに通知する、ということをすればオーケーです。

```ruby
# railsで、config/initializers/に配置したファイルに書く

Sidekiq.configure_server do |config|
  config.death_handlers << -> (job, _exception) do
    ::Sentry.capture_message("ワーカークラス名:#{job['class']} が失敗しました")

    # NOTE: なお、ここで_exceptionに例外が入っているのでそれを用いてハンドリングすることもできるかもしれない
  end
end
```

### ✎まとめ

というわけで Sidekiqの`death_handlers` 便利です

<script type="text/javascript" src="/js/prism.js" async></script>
