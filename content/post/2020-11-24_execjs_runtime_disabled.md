+++
date = "2020-11-24T01:22:00+09:00"
draft = false
title = "`ExecJS::RuntimeUnavailable` エラーは EXECJS_RUNTIME=Disabled で回避できるときがある"
slug = "execjs_runtime_disabled"
tags = ["rails","node"]
# image = "images/slack_display.png"
image = "defimg/3.jpg"
+++

`ExecJS::RuntimeUnavailable` で ググってもあまり出てこなかったので書いておく。

<!--more-->

railsコマンドやrakeコマンドで、`ExecJS::RuntimeUnavailable` エラーが起きてしまうことがある。

普通はあんまり起きないんだけど、railsアプリで、以下のようなケース。

* dockerのmulti-stageビルドを駆使していてダイエットしていて、最終的に出来上がるdockerイメージに `nodejs` (とか)が無い
* `execjs` gem を利用している
    * 例えば、`autoprefixer-rails` gem や、それに依存してる `bootstrap` (twitter bootstrap) gemを使っている

( productionでbootstrap gemを使わなきゃいいだろ、と言われそうだが、bootstrap gemに依存してるgemがあってな.....😂)


### 回避策

`nodejs` とかを入れる、のがまあ回避策になるんだけど、


環境変数 `EXECJS_RUNTIME` に `Disabled` を入れることで回避できることを知った。

もちろん、`rake assets:precompile` とかを走らせるときはダメだと思う。
その場合は普通に `nodejs` とかを入れる。

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">How to disable ExecJS in production: upgrade to 1.3.0 and set ENV[&#39;EXECJS_RUNTIME&#39;] = &#39;Disabled&#39; before Bundler.require</p>&mdash; Jon Leighton (@jonleighton) <a href="https://twitter.com/jonleighton/status/179542450547851265?ref_src=twsrc%5Etfw">March 13, 2012</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>


execjs gemに [そういうクラスがある](https://github.com/rails/execjs/blob/5f78865d36976f85b42e8529dec272285d8f3b85/lib/execjs/disabled_runtime.rb)

Nullオブジェクトパターンってこういうパターンだっけかな

<script type="text/javascript" src="/js/prism.js" async></script>
