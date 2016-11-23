+++
date = "2016-11-23T13:00:00+09:00"
draft = false
title = "このブログの編集方法とデプロイ方法について(github pages + hugo)"
slug = "deploy_this_blog"
tags = ["blog","hugo","github-pages"]
image = "images/hugo.png"

+++

このブログ、[https://hoshinotsuyoshi.com](https://hoshinotsuyoshi.com)の編集方法とデプロイ方法についての説明です。

hugoでhtmlを生成し、github pagesでホスティングしています。
あまり奇をてらったやり方はしていません。至って普通です。

<!--more-->

#### 準備

##### hugoをインストール

<a class="embedly-card" href="https://gohugo.io/">Hugo :: A fast and modern static website engine</a>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

[hugo](https://gohugo.io/)は、高速なhtml生成ツールです。
brewでインストールします。

```
$ brew install hugo
```

##### このブログのリポジトリをクローン

githubに置いてあります。

<a class="embedly-card" href="https://github.com/hoshinotsuyoshi/hoshinotsuyoshi.com">hoshinotsuyoshi/hoshinotsuyoshi.com</a>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

クローンします。

```
$ go get github.com/hoshinotsuyoshi/hoshinotsuyoshi.com
```

##### ローカルでサーバーを立てつつ記事を編集する

`$ rake s` とやるとローカルにサーバが立ちます。

```
$ rake s

hugo server -t casper
Started building sites ...
...snip...
Serving pages from memory
Web Server is available at http://localhost:1313/ (bind address 127.0.0.1)
Press Ctrl+C to stop
```

この状態で`content/post`以下のファイルを追加・編集するとすぐ変更が反映されます。

例えば画像を貼ります。すぐ反映されます。
<img src="/images/blog_ani.gif">

##### デプロイする

`$ rake`でデプロイできます。
