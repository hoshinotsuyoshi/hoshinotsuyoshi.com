+++
date = "2021-11-21T10:52:29+09:00"
draft = false
title = "RodaでAPIサーバー"
slug = "study_roda"
tags = ["rails","ruby"]
image = "defimg/1.jpg"
+++

Roda試してみたかったので、APIサーバーを書けるかやってみました

<!--more-->

### 書いてみたソース

https://github.com/hoshinotsuyoshi/study-roda/tree/v1

### こんなかんじ

ほぼREADMEどおりだけど、こんなかんじ。

`plugin :json` でJSONが返せる。

```ruby
# frozen_string_literal: true
require "roda"

class App < Roda
  plugin :json

  route do |r|
    # GET / request
    r.root do
      r.redirect "/hello"
    end

    # /hello branch
    r.on "hello" do
      # Set variable for all routes in /hello branch
      @greeting = 'Hello'

      # GET /hello/world request
      r.get "world" do
        { greeting: "#{@greeting} world!" }
      end

      # /hello request
      r.is do
        # GET /hello request
        r.get do
          { greeting: "#{@greeting}!" }
        end

        # POST /hello request
        r.post do
          puts "Someone said #{@greeting}!"
          r.redirect
        end
      end
    end
  end
end

run App.freeze.app
```

Sinatraに似てる。

作者いわく、Sinatraよりちょっと長くなるけど、シンプルでしょ、ということらしい。

http://roda.jeremyevans.net/compare_to_sinatra.html


### うごかす

```yaml
# Procfile
web: bundle exec falcon serve -b http://localhost:9292
ab: ab -c 3 -t 3 'http://localhost:9292/hello'
```

意味なくfalcon使ってみた。

`$ bundle exec foreman run web` で falconが動き、

`$ bundle exec foreman run ab` で Apatche Benchが動く。

手元の環境だとサーバーは8プロセスぐらい立ち上がって 4000req/sec とか動いた。


<script type="text/javascript" src="/js/prism.js" async></script>
