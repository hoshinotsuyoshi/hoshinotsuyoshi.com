+++
date = "2021-12-25T16:38:48+09:00"
draft = false
title = "Railsで`config/x`みたいなディレクトリ作るとymlが分かりやすくなる説"
slug = "rails_config_for"
tags = ["rails","ruby"]
image = "images/config_for.png"
+++

Railsで`config/x`みたいなディレクトリ作ってそこに `config_for` で読み込むymlを置くとスッキリして分かりやすくなるんじゃないか という思いがあり、それについて書きます。

<!--more-->

## TOC

1. Railsで `Rails.configuration` と `config_for` を活用する話
    * `config.x.なんか` と `config.なんか` の違いとはなんなのか
1. そうすると `config/*.yml` がいっぱいできるじゃん？
    * 見通しの悪さよ
1. アイデア: アプリの独自設定は `config/x/*.yml` に置いたらいいのでは?


<br>

## Railsで `Rails.configuration` と `config_for` を活用する話

<br>

まず、`Rails.configuration` と `config_for` についてです。

これはRails4.2から導入されたもので、それまでの [config gem](https://github.com/rubyconfig/config)(懐かしい)や [settings_logic gem](https://github.com/binarylogic/settingslogic) (懐かしい)の代わりになるものでした

以下は最新7.0バージョンのrailsガイド(https://guides.rubyonrails.org/configuring.html#custom-configuration) からの抜粋です。

### まず `Rails.configuration`

設定するときは `config/application.rb` などで

```ruby
config.x.payment_processing.schedule = :daily
config.x.payment_processing.retries  = 3
config.super_debugger = true
```

呼び出すときは任意の場所で

```ruby
Rails.configuration.x.payment_processing.schedule # => :daily
Rails.configuration.x.payment_processing.retries  # => 3
Rails.configuration.x.payment_processing.not_set  # => nil
Rails.configuration.super_debugger                # => true
```

のように使います。


### 次に`config_for` について

`config_for`はyamlを読み込むためのメソッドです。

`Rails.configuration` にセットするために使う例が多いです。

```yaml
# config/payment.yml
production:
  environment: production
  merchant_id: production_merchant_id
  public_key:  production_public_key
  private_key: production_private_key

development:
  environment: sandbox
  merchant_id: development_merchant_id
  public_key:  development_public_key
  private_key: development_private_key
```

のようなyamlを配置し、`config/application.rb` で `config.なにか`(または`config.x.なにか`) にセットします。

```ruby
# config/application.rb
module MyApp
  class Application < Rails::Application
    config.payment = config_for(:payment)
  end
end
```

↑ここでは`x` を使わずに `config.payment=`とセットしているので、

呼び出すときは以下のように呼び出します。

```ruby
Rails.configuration.payment['merchant_id'] # => production_merchant_id or development_merchant_id
```

`x` を挟んで `config.x.payment=` みたいにセットすることもできます。


```ruby
# config/application.rb
module MyApp
  class Application < Rails::Application
    config.x.payment = config_for(:payment) # `x` を挟んだ
  end
end
```

この場合は呼び出すときも `x` を挟み、以下のような感じで取り出すことができます。

```ruby
Rails.configuration.x.payment['merchant_id'] # => production_merchant_id or development_merchant_id
```


### `config.x.なんか` と `config.なんか` の違いとはなんなのか

実装上の話をすると、「ネストできる」のが `config.x.なんか` です。

```ruby
# 例
config.x.payment_processing.schedule = :daily
```

今のrailsガイド的には、それ以外の意味はなさそうです。

が、なんとなく `x` と付けるのは、httpの独自ヘッダーみたいに、**独自的・局所的な要素であることの印象**を受けます(私だけでしょうか)


## そうすると `config/*.yml` がいっぱいできるじゃん？

<br>

`x` を使っても使わなくてもどちらの場合でもそうなのですが、

以上のようなことを活用していくとconfig/の下がymlでいっぱいになります。


config/の下のファイルたちのイメージ:

```
application.rb
bar.yml
baz.yml
boot.rb
cable.yml
corge.yml
database.yml
environment.rb
environments/
foo.yml
fred.yml
garply.yml
grault.yml
initializers/
locales/
newrelic.yml
plugh.yml
puma.rb
quux.yml
qux.yml
routes.rb
sidekiq.yml
spring.rb
storage.yml
thud.yml
waldo.yml
webpack/
webpacker.yml
```



### 見通しの悪さよ

<br>

いっぱいになる分には良いのですが、

「(Railsを初めとした) **`config/`の下に設定ファイルを置く規約にしているgemのyamlと区別がつかなくなってしまう**」という問題があります。

具体的には、

* `config/cable.yml` と `config/database.yml` が置いてあるが、これはRails由来。
* `config/sidekiq.yml` は 3rd party gem(sidekiq gem)由来。
* `config/newrelic.yml` は 3rd party gem(newrelic gem)由来。
* それ以外の `config/*.yml` は `config/applicaition.rb` から `config_for` で呼んでいる

みたいな感じです。

つまりconfig/の下のファイルたちにコメントを付けると、以下のような感じです。


```
application.rb
bar.yml          # このrails app独自のもの
baz.yml          # このrails app独自のもの
boot.rb
cable.yml        # rails由来
corge.yml        # このrails app独自のもの
database.yml     # rails由来
environment.rb
environments/
foo.yml          # このrails app独自のもの
fred.yml         # このrails app独自のもの
garply.yml       # このrails app独自のもの
grault.yml       # このrails app独自のもの
initializers/
locales/
newrelic.yml     # newrelic gem由来
plugh.yml        # このrails app独自のもの
puma.rb
quux.yml         # このrails app独自のもの
qux.yml          # このrails app独自のもの
routes.rb
sidekiq.yml      # sidekiq gem由来
spring.rb
storage.yml      # rails由来
thud.yml         # このrails app独自のもの
waldo.yml        # このrails app独自のもの
webpack/
webpacker.yml    # rails由来
```

詳しい人が見ればわかるのですが、パッと見で分かりづらくなってしまいます。

## アイデア: アプリの独自設定は `config/x/*.yml` に置いたらいいのでは?

<br>

そこで提案なんですが、

実は、`config_for` は 引数を調整することにより、`config/` 以外を読むことができます! のでこれを活用したらいいと思います!

(rails5.0から変わりました。該当のコミット: https://github.com/rails/rails/commit/fc635b565393bd6b70be4af524934b3ea359e83c 。 )

これにより、config/application.rbは以下のように書き換えることができます。


```ruby
# config/application.rb
module MyApp
  class Application < Rails::Application
    config.x.bar   = config_for(Rails.root.join('config/x/bar.yml'))
    config.x.baz   = config_for(Rails.root.join('config/x/baz.yml'))
    config.x.corge = config_for(Rails.root.join('config/x/corge.yml'))
    # ...snip...
    config.x.waldo = config_for(Rails.root.join('config/x/waldo.yml'))
  end
end
```


こうすることで、Railsや3rd party gemがconfig/の下に配置するymlと区別がつきやすくなります

config/の下のファイル。 イメージ:

```
# config/
application.rb
boot.rb
cable.yml        # rails由来
database.yml     # rails由来
environment.rb
environments/
initializers/
locales/
newrelic.yml     # newrelic gem由来
puma.rb
routes.rb
sidekiq.yml      # sidekiq gem由来
spring.rb
storage.yml      # rails由来
webpack/
webpacker.yml    # rails由来
x/
```

config/xの下のファイル。 イメージ:

```
# config/x/
bar.yml          # このrails app独自のもの
baz.yml          # このrails app独自のもの
corge.yml        # このrails app独自のもの
foo.yml          # このrails app独自のもの
fred.yml         # このrails app独自のもの
garply.yml       # このrails app独自のもの
grault.yml       # このrails app独自のもの
plugh.yml        # このrails app独自のもの
quux.yml         # このrails app独自のもの
qux.yml          # このrails app独自のもの
thud.yml         # このrails app独自のもの
waldo.yml        # このrails app独自のもの
```

このように分離されることにより、スッキリしますよね!


## まとめ

このエントリでは、`config/x` のようなディレクトリを作りそこにymlファイルを置くことにより、設定用のymlファイルを整理する検討を行いました。


<script type="text/javascript" src="/js/prism.js" async></script>
