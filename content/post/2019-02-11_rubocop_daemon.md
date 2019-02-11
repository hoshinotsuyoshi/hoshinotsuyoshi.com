+++
date = "2019-02-11T15:34:34+09:00"
draft = false
title = "rubocop-daemonでneovimでのオートコレクトを速くする"
slug = "rubocop_daemon"
tags = ["vim","ruby","neovim","rubocop","rubocop-daemon"]
image = "images/robot1.jpg"

+++

速くなるっぽいので、試してみる!!

### 動作

<img alt="rubocop_daemon" src="/images/rubocop_daemon_hash.gif" width=600>

<!--more-->

### 使ったやつ: rubocop-daemon

<a class="embedly-card" data-card-key="6f257114b6df4413a3f5872a7e143278" data-card-controls="0" data-card-type="article" href="https://github.com/fohte/rubocop-daemon">fohte/rubocop-daemon</a>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>


### 普通の場合

([ruby-formatter/rufo](https://github.com/ruby-formatter/rufo)のissuesの[ここ](https://github.com/ruby-formatter/rufo/issues/2#issuecomment-439104627)に書かれたサンプルrubyファイルで試した。)

`:w` で保存 -> オートコレクトが終わるまでに **2.5秒**ぐらい。

<img alt="rubocop_daemon" src="/images/rubocop_daemon_before.gif" width=600>

### ウラでrubocop-daemonが動いている場合

`:w` で保存 -> オートコレクトが終わるまでに **0.6秒** ぐらい。

**2秒ぐらい速くなった!!!**

<img alt="rubocop_daemon" src="/images/rubocop_daemon_after.gif" width=600>

---

## 設定・今回どう動かしたか

[fohte/rubocop-daemon](https://github.com/fohte/rubocop-daemon)にvimの説明が無かったので、適当に設定しました。完全オレオレ設定です。

### daemonの起動

rubocop-daemonはneovim経由ではなく普通に動かす。

[rubocop-daemon gem](https://rubygems.org/gems/rubocop-daemon)が必要になる。

```sh
$ rubocop-daemon start
```

<br/>

### neovim側の設定

すでに[aleで保存時にオートコレクトが走る](https://hoshinotsuyoshi.com/post/neovim_rubocop_autocorrect/)ようにしているので、neovim上で`rubocop`コマンドを叩いた時、代わりに`rubocop-daemon exec` が叩かれるようにする。

READMEの[ここ](https://github.com/fohte/rubocop-daemon/tree/v0.3.1#more-speed)に書かれてるラッパースクリプトをダウンロードし、適当なディレクトリに配置。

```sh
# ラッパースクリプトのダウンロード。
$ curl https://raw.githubusercontent.com/fohte/rubocop-daemon/master/bin/rubocop-daemon-wrapper -o /tmp/rubocop-daemon-wrapper

# 自分の場合はディレクトリはここにした。
# どこに置くと良いのかわからない。
$ mkdir -p ~/.rubocop

# 今回の用途としては"rubocop"として保存。
# aleの設定をそのまま利用したいため。
$ mv /tmp/rubocop-daemon-wrapper ~/.rubocop/rubocop
$ chmod +x ~/.rubocop/rubocop
```

`~/.config/nvim/init.vim`で、この`rubocop`ファイルを見つけられるようにする。

```vimscript
" nvim限定・rubocopへのパス
let $PATH="/Users/hoshino/.rubocop:".$PATH
```

設定は以上!

<br/>

### この設定の所感

* vim強い人にどうすればいいか聞きたい
* .rubocop.ymlに修正が入ったり、利用するrubocopのバージョンが変わる時にいちいちdaemonのリスタートが必要。

### その他所感

元々、テキストエディタ上のlinterとして使うには`rubocop -a` が遅いと言っている人がいる

* https://github.com/rubocop-hq/rubocop/issues/6492
* https://github.com/ruby-formatter/rufo/issues/2#issuecomment-439104627

そして、そもそも[コマンド起動時にライブラリを全部読み込むところが遅い](https://github.com/rubocop-hq/rubocop/issues/6492#issuecomment-439736434)というコメントがある。

これ実際私も時間を測ってみたのだが、たしかに! という印象だった。

エディタ上のauto-correctは確かに遅いが、別にauto-correctじゃなくても遅そう。

なので、エディタ上でrubocopを使うのにおいて、「ライブラリを全部読み込む時間を、daemon活用によりショートカットする」というアプローチは、ある程度納得できる気がする。

1週間ぐらい仕事で使ってみて様子を見たい。



<script type="text/javascript" src="/js/prism.js" async></script>

---

photograph: [www.flickr.com,Alexandre Dulaunoy](https://www.flickr.com/photos/adulau/1331582337)

---


{{% pixela_access_counter "hoshinotsuyoshi/graphs/hblog-20190211-1" %}}
